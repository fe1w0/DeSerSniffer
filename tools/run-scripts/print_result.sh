#!/bin/bash
# author: fe1w0

dir="$(dirname "$BASH_SOURCE")"

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
                echo -e "\tID: ${GREEN}$ID$padding - ${GREEN}Completed   ✅${NO_COLOR}"
            fi
        else
            echo -e "\t${RED}ID: ${RED}$ID$padding - ${RED}In Progress ${RED}❎${NO_COLOR}"
            echo -e "${RED}\t\t- Logs:${NO_COLOR}"
            echo -e "${RED}\t\t\t- $log_file${NO_COLOR}"
            echo -e "${RED}\t\t\t- ${DOOP_HOME}/build/logs/doop.log${NO_COLOR}"
        fi

    done
}


# 函数: 输出所有的检测结果
#       查询 DOOP_OUT 下所有的 LeakingTaintedInformation.csv 中的结果（多少行）。
#       列出 有结果的 LeakingTaintedInformation.csv (数量和内容)，且需要输出 DOOP_OUT/${ID}/database/LeakingTaintedInformation.csv 中的 ID
get_result() {
    echo $module_separator
    echo -e "\n[+] Analysis Result:"

    # 计算 ID 的最大长度
	max_id_length=0
	for dir in $(find $DOOP_OUT -maxdepth 1 -mindepth 1 -type d); do
		ID=$(basename "$dir")
		if [ ${#ID} -gt $max_id_length ]; then
			max_id_length=${#ID}
		fi
	done

    # 检查 DOOP_OUT 是否存在
    if [ ! -d "$DOOP_OUT" ]; then
        echo "Error: DOOP_OUT directory does not exist."
        return 1
    fi

    # 声明关联数组
	declare -A results

	# 遍历 DOOP_OUT 下的所有子目录
	for dir in $(find $DOOP_OUT -maxdepth 1 -mindepth 1 -type d); do
		# 获取 ID
		ID=$(basename "$dir")

		# 检查 LeakingTaintedInformation.csv 是否存在
		file="$dir/database/LeakingTaintedInformation.csv"
		if [ -f "$file" ]; then
			# 计算文件行数
			lines=$(wc -l < "$file")
			# 如果文件非空，则保存到数组
			if [ "$lines" -gt 0 ]; then
				results["$ID"]=$lines
			fi
		fi
	done

	# 按照 ID 的字符串排序并输出结果
	for ID in $(echo ${!results[@]} | tr ' ' '\n' | sort); do
		local padding=$(printf '%*s' $((max_id_length - ${#ID})))
		echo -e "\t${RED}ID: ${ID}${padding} - Lines: ${results[$ID]} ${RED}❌${NO_COLOR}"
		echo -e "\t${RED}ID: ${ID}${padding} - PotentialVulnGraph: $(wc -l < $DOOP_OUT/$ID/database/PotentialVulnGraph.csv) ${RED}❌${NO_COLOR}"
		echo -e "\t\tFile:\n\t\t\t- $(ls $DOOP_OUT/$ID/database/PotentialVulnGraph.csv)"
		echo -e "\t\t\t- $(ls $DOOP_OUT/$ID/database/LeakingTaintedInformation.csv)"
	done

    echo $module_separator

    # 遍历 DOOP_OUT 下的所有子目录
    for dir in $(find $DOOP_OUT -maxdepth 1 -mindepth 1 -type d); do
        # 获取 ID
        local ID=$(basename "$dir")

        # 检查 LeakingTaintedInformation.csv 是否存在
        local file="$dir/database/LeakingTaintedInformation.csv"

        if [ -f "$file" ]; then
            # 计算文件行数
            lines=$(wc -l < "$file")
            # 如果文件非空，则输出内容
            if [ "$lines" -gt 0 ]; then
                # 输出信息
                printf "\tID: ${RED}%s\t ❗️${NO_COLOR}\n\tFile: \n\t\t%s\n\tNumber: %s\n" "$ID" "$file" "$lines"
                echo -e "\t\tContents of $file:" 
                echo "$separator"
                echo -e "${RED}$(cat "$file" | sed 's/^/\t/' | sed 's/$/\n/') ${NO_COLOR}\n"
                echo "$separator"            
            fi
        fi
    done
}


print_result() {
    echo $module_separator
    print_centered " Print Analysis Result "

    # 调用 get_tasks 函数
    get_tasks 

    # 调用 get_result 函数
    get_result 
}

doop_config

print_result
