#!/bin/bash
# author: fe1w0

dir="$(dirname "$BASH_SOURCE")"

trap 'echo "Script interrupted."; exit' SIGINT

# execute_tasks 和 execute_results 变量来控制是否执行 get_tasks 和 get_result
execute_tasks=false
execute_results=false
execute_only_table=false
enable_id=false

# 函数: 打印帮助信息
print_help() {
    echo -e "  Usage: $0 [options]"
    echo -e "\tOptions:"
    echo -e "\t  -t     Execute tasks"
    echo -e "\t  -r     Execute results"
    echo -e "\t  -o     Execute only table"
    echo -e "\t    -i     Enable ID (base on -o)"
    echo -e "\t  -h     Display this help and exit"
}

# 解析命令行选项
while getopts "troih" opt; do
  case $opt in
    t)
      execute_tasks=true
      ;;
    r)
      execute_results=true
      ;;
	o)
	  execute_only_table=true
	  ;;
	i)
	  enable_id=true
	  ;;
	h)
      print_help
      exit 1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done


# 加载 doop 配置模块, doop_config 提供 DOOP_OUT
source ${dir}/utils/config/doop_config.sh

# 加载 print 模块
source ${dir}/utils/print/print_separator.sh


# ANSI 颜色代码
RED='\033[0;31m'
GREEN='\033[0;32m'
NO_COLOR='\033[0m' # 没有颜色

# 函数: 输出已完成检测和正在检测的项目
#       通过查看log目录下的 ${ID}.log 文件
#           完成: log目录下存在${ID}.log文件，且文件内容中有 "End Time"
#           未完成: log目录下存在${ID}.log文件，但没有 "End Time"
get_tasks() {
	local TasksNumber=0
	
    echo $module_separator
    echo -e "\n[+] Tmp Logs:"
    echo -e "$GREEN$(ls -Atr /tmp/doop* | sed 's/^/\t- /' ) $NO_COLOR"

    echo $module_separator

    echo -e "\n[+] Tasks Status:"

    local log_dir="${DOOP_OUT}/log"
    if [ ! -d "$log_dir" ]; then
        echo "Error: log directory does not exist."
        return 1
    fi

    # 计算 ID 的最大长度
    local max_id_length=0
    for log_file in "$log_dir"/*.log; do
        if [ -f "$log_file" ]; then
            local id_length=$(basename "$log_file" .log | wc -m)
            if [ $id_length -gt $max_id_length ]; then
                max_id_length=$id_length
            fi
        fi
    done

    # 遍历 log 目录下的所有 .log 文件
    for log_file in "$log_dir"/*.log; do
        if [ ! -f "$log_file" ]; then
            continue
        fi

		TasksNumber=$(($TasksNumber+1))

        local ID=$(basename "$log_file" .log)
        local padding=$(printf '%*s' $((max_id_length - ${#ID})))

        # 检查文件内容中是否有 "End Time"，不显示错误信息
        if grep -q "End:  " "$log_file" 2>/dev/null; then
            # 如果出现错误
            if grep -q "Monitoring DOOP Log for Error" "$log_file" 2>/dev/null; then
                
                echo -e "\t${RED}ID: ${RED}$ID$padding - ${RED}Error ${RED}❌${NO_COLOR}"
                
                echo -e "${RED}\t\t- Error Types:${NO_COLOR}"
                
                # 检测 INPUT 无法生成
                if grep -q "ERROR: Doop error" "${log_file}" 2>/dev/null; then
                    echo -e "${RED}\t\t\t- INPUT Error: ${ID}${NO_COLOR}"
                fi

                # Souffle 问题
                if grep -q "Error ${ID}" "${log_file}" 2>/dev/null; then
                    SubID=$(grep "Error ${ID}" "${log_file}" -A 1 | grep -o -E "${ID}_[0-9]+" | head -n 1)
                    echo -e "${RED}\t\t\t- Souffle Error: $SubID${NO_COLOR}"
                fi
                echo -e "${RED}\t\t- Logs:${NO_COLOR}"
                echo -e "${RED}\t\t\t- $log_file${NO_COLOR}"
                echo -e "${RED}\t\t\t- ${DOOP_HOME}/build/logs/doop.log${NO_COLOR}"
            # 没有出现错误
            else
					if grep -q "无可分析对象" "$log_file" 2>/dev/null; then
						echo -e "\t${RED}ID: ${RED}$ID$padding - ${RED}Error ${RED}❌${NO_COLOR}"
                		echo -e "${RED}\t\t- Error Types:${NO_COLOR}"
						echo -e "${RED}\t\t\t- No ListReadObjectClass.csv: ${ID}${NO_COLOR}"
						echo -e "${RED}\t\t- Logs:${NO_COLOR}"
               			echo -e "${RED}\t\t\t- $log_file${NO_COLOR}"
                		echo -e "${RED}\t\t\t- ${DOOP_HOME}/build/logs/doop.log${NO_COLOR}"
            # 没有出现错误
					else 
						echo -e "\tID: ${GREEN}$ID$padding - ${GREEN}Completed   ✅${NO_COLOR}"
						echo -e "${GREEN}\t\t- Logs:${NO_COLOR}"
						echo -e "${GREEN}\t\t\t- $log_file${NO_COLOR}"
						echo -e "${GREEN}\t\t\t- ${DOOP_HOME}/build/logs/doop.log${NO_COLOR}"
					fi
            fi
        else
            echo -e "\t${RED}ID: ${RED}$ID$padding - ${RED}In Progress ${RED}❎${NO_COLOR}"
            echo -e "${RED}\t\t- Logs:${NO_COLOR}"
            echo -e "${RED}\t\t\t- $log_file${NO_COLOR}"
            echo -e "${RED}\t\t\t- ${DOOP_HOME}/build/logs/doop.log${NO_COLOR}"
        fi
		
    done

	echo -e "\n[+] TasksNumber: ${TasksNumber}"
}


# 函数: 输出所有的检测结果
#       查询 DOOP_OUT 下所有的 LeakingTaintedInformation.csv 中的结果（多少行）。
#       列出 有结果的 LeakingTaintedInformation.csv (数量和内容)，且需要输出 DOOP_OUT/${ID}/database/LeakingTaintedInformation.csv 中的 ID
get_result() {

    echo $module_separator
    echo -e "\n[+] Analysis Result:"

    # 检查 DOOP_OUT 是否存在
    if [ ! -d "$DOOP_OUT" ]; then
        echo "Error: DOOP_OUT directory does not exist."
        return 1
    fi

    # 直接在 DOOP_OUT 目录下查找并处理文件
	while read leakingFile; do
        ID=$(basename $(dirname "$(dirname "$leakingFile")"))

        leakingLines=$(wc -l < $leakingFile)
		
		declare tmp_list=(0 0 0)

		if [ $leakingLines -gt 0 ]; then
			potentialFile=$(dirname "$leakingFile")/PotentialVulnGraph.csv
			reachableFile=$(dirname "$leakingFile")/ReachablePotentialVulnGraph.csv

			echo -e "\t${RED}ID: ${ID}${NO_COLOR}"
			echo -e "\t\tResult:"
			echo -e "\t\t\t - LeakingTaintedInformation: $leakingLines"

			tmp_list[0]=$leakingLines

			potentialLines=$(wc -l < $potentialFile)
			reachableLines=$(wc -l < $reachableFile)

			if [ $potentialLines -gt 0 ]; then
				tmp_list[1]=$potentialLines
				echo -e "\t\t\t - PotentialVulnGraph: $potentialLines"
			elif [ $potentialLines -eq 0 ]; then
				echo -e "\t\t\t - ${RED} PotentialVulnGraph: $potentialLines  $NO_COLOR"
			fi

			if [ $reachableLines -gt 0 ]; then
				tmp_list[2]=$reachableLines
				echo -e "\t\t\t - ReachablePotentialVulnGraph: $reachableLines"
			elif [ $reachableLines -eq 0 ]; then
				echo -e "\t\t\t - ${RED} ReachablePotentialVulnGraph: $reachableLines $NO_COLOR"
			fi

			echo -e "\t\tFile:"
			echo -e "\t\t\t- $leakingFile"
			cat $leakingFile
			
			if [ $potentialLines -gt 0 ]; then
				echo -e "\t\t\t- $potentialFile"
			fi

			if [ $reachableLines -gt 0 ]; then
				echo -e "\t\t\t- $reachableFile"
			fi

			result_map[$ID]=${tmp_list[@]}
		fi
	done < <(find "$DOOP_OUT" -maxdepth 3 -mindepth 3 -type f -name "LeakingTaintedInformation.csv") 
}

get_table() {
	echo $module_separator
	declare -i result_number=0

	# 输出 result_map 表格
	echo -e "\n[+] Summary of Analysis Results:"
	echo -e "\tID\tLeakingLines\tPotentialLines\tReachableLines"
	for id in "${!result_map[@]}"; do
		result_number=$(($result_number+1))
		results=(${result_map[$id]}) # 将字符串转换为数组
		echo -e "\t$id\t${results[0]}\t${results[1]}\t${results[2]}"
	done

	echo -e "\n[+] ResultNumber: ${result_number}"
}

# 新函数: 在 execute_only_table 下读取用户输入的 ID 并显示对应的 LeakingTaintedInformation 文件
read_id_and_cat_leaking() {
    if $execute_only_table && $enable_id; then
        echo "Please enter the user ID:"
        read task_id  # 从用户那里读取 ID

        local leaking_file="${DOOP_OUT}/${task_id}/database/LeakingTaintedInformation.csv"
        if [ -f "$leaking_file" ]; then
            echo "LeakingTaintedInformation for ID ${task_id}:"
            cat "$leaking_file" | sed 's/^/\n/'  
        else
            echo "No LeakingTaintedInformation file found for ID ${task_id}."
        fi
    fi
}

print_result() {
	# 全局的分析结果变量
	declare -A result_map=()

    echo $module_separator

    print_centered " Print Analysis Result "

	# 根据选项执行相应的函数
	if $execute_tasks; then
		get_tasks
	fi

	if $execute_results; then
		get_result
	fi

	if $execute_only_table; then
		get_result > /dev/null
		get_table
		read_id_and_cat_leaking
	fi
}

doop_config

if ! $execute_only_table && $enable_id ; then
	print_help
	exit 1
fi

if ! $execute_tasks && ! $execute_results && ! $execute_only_table; then
	get_tasks
	get_result
	get_table
elif [ $execute_tasks || $execute_results || $execute_only_table ] ; then
	print_result
fi
