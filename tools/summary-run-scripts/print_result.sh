#!/bin/bash
# author: fe1w0

MAIN_DIR="$(dirname "$BASH_SOURCE")"

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
    echo -e "\t  -p     Execute only table"
    echo -e "\t    -i     Enable ID (base on -p)"
	echo -e "\t  -o     Execute export file"
    echo -e "\t  -h     Display this help and exit"
}

# 解析命令行选项
while getopts "trpih" opt; do
  case $opt in
    t)
      execute_tasks=true
      ;;
    r)
      execute_results=true
      ;;
	p)
	  execute_only_table=true
	  ;;
	i)
	  enable_id=true
	  ;;
	o)
	  enable_export=true
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
source ${MAIN_DIR}/utils/config/doop_config.sh

# 加载 print 模块
source ${MAIN_DIR}/utils/print/print_separator.sh

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
			potentialFile=$(dirname "$leakingFile")/readObject.ListReadObjectMethod.csv
			reachableFile=$(dirname "$leakingFile")/ReachabelSinkingMethod.csv

			echo -e "\t${RED}ID: ${ID}${NO_COLOR}"
			echo -e "\t\tResult:"
			echo -e "\t\t\t - LeakingTaintedInformation: $leakingLines"

			# 获得 $leakingFile 的修改时间
			leaking_file_info=$(stat "$leakingFile" 2>/dev/null)
			modification_time=$(echo "$leaking_file_info" | grep "Modify:" | awk '{print $2, $3}')
			formatted_time=$(echo "$modification_time" | cut -d. -f1)

			# 计算文件行数
			potentialLines=$(wc -l < $potentialFile)
			reachableLines=$(wc -l < $reachableFile)
			
			# 添加到表格中
			tmp_list[0]=$(echo $formatted_time | sed 's/ /-/')
			tmp_list[1]=$leakingLines
			tmp_list[2]=$potentialLines
			tmp_list[3]=$reachableLines

			if [ $potentialLines -gt 0 ]; then		
				echo -e "\t\t\t - PotentialVulnGraph: $potentialLines"
			elif [ $potentialLines -eq 0 ]; then
				echo -e "\t\t\t - ${RED} PotentialVulnGraph: $potentialLines  $NO_COLOR"
			fi

			if [ $reachableLines -gt 0 ]; then
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
	done < <(find "$DOOP_OUT" -maxdepth 3 -mindepth 3 -type f -name "TaintedSinkMethod.csv") 
}

get_table() {
    echo $module_separator
    declare -i result_number=0

    # 计算 ID 列的最大宽度
    max_id_length=0
    for id in "${!result_map[@]}"; do
        if [ ${#id} -gt $max_id_length ]; then
            max_id_length=${#id}
        fi
    done

    # 输出 result_map 表格
    echo -e "\n[+] Summary of Analysis Results:"
    printf "%-${max_id_length}s\t%-25s\t%-25s\t%-25s\t%-25s\n" "ID" "Time" "TaintedSinkMethod" "ListReadObjectMethod" "ReachabelSinkingMethod"
    for id in "${!result_map[@]}"; do
        result_number=$(($result_number + 1))
        results=(${result_map[$id]}) # 将字符串转换为数组

        # 使用 printf 格式化输出，确保各列对齐
        printf "%-${max_id_length}s\t%-25s\t%-25s\t%-25s\t%-25s\n" "$id" "${results[0]}" "${results[1]}" "${results[2]}" "${results[3]}"
    done

    echo -e "\n[+] ResultNumber: ${result_number}"
}

# 新函数: 在 execute_only_table 下读取用户输入的 ID 并显示对应的 TaintedSinkMethod 文件
read_id_and_cat_leaking() {
    if $execute_only_table && $enable_id; then
        echo "Please enter the user ID:"
        read task_id  # 从用户那里读取 ID

        local leaking_file="${DOOP_OUT}/${task_id}/database/TaintedSinkMethod.csv"
        if [ -f "$leaking_file" ]; then
            echo "TaintedSinkMethod for ID ${task_id}:"
            cat "$leaking_file" | sed 's/^/\n/'  
        else
            echo "No TaintedSinkMethod file found for ID ${task_id}."
        fi
    fi
}

export_file() {
	declare -g output_csv_file=$BASE_DIR/output/AllLeakingInformation.csv
	echo -e "Source\tSink" > $output_csv_file

	while read leakingFile; do
        ID=$(basename $(dirname "$(dirname "$leakingFile")"))
		
		leakingLines=$(wc -l < $leakingFile)
	
		if [ $leakingLines -gt 0 ]; then
			cat $leakingFile >> $output_csv_file
		fi

	done < <(find "$DOOP_OUT" -maxdepth 3 -mindepth 3 -type f -name "TaintedSinkMethod.csv") 

	echo -e "[+] ExportResult: ${output_csv_file}"
}

print_result() {
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

# 全局的分析结果变量
declare -A result_map=()

doop_config

if ! $execute_only_table && $enable_id ; then
	print_help
	exit 1
fi

if ! $execute_tasks && ! $execute_results && ! $execute_only_table ;  then
	get_tasks
	get_result
	get_table
elif $execute_tasks || $execute_results || $execute_only_table ; then
	print_result
fi

if $enable_export; then
	export_file
fi