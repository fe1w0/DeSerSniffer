#!/bin/bash
# author: fe1w0

# 函数：分割CSV文件
split_csv() {
    local ID=$1       # 输入项目ID
    local input=${DOOP_OUT}/init_${ID}/database/ListReadObjectClass.csv
    local line_count=$2  # 每个文件存储的行数
    local counter=0      # 总行数计数器
    local fileNumber=1   # 文件序号
    local output         # 输出文件名
    ReturnCsvNumber=0    # 最后输出结果

	echo "CurrentLOG:" $CurrentLOG

    # 检查文件是否存在 或者 无内容
    if [ ! -f "$input" ]; then
        echo "[-] $(print_time) 文件不存在: $input" | tee -a $CurrentLOG
        return 1
    elif [ ! -s "$input" ]; then
        echo "[-] $(print_time) 无可分析对象: $input" | tee -a $CurrentLOG
        return 1
    fi

    # 检查行数参数
    if ! [[ "$line_count" =~ ^[0-9]+$ ]]; then
        echo "[-] $(print_time) 无效的行数: $line_count" | tee -a $CurrentLOG
        return 1
    fi

    # 读取文件并分割
    while IFS= read -r line
    do
        # 每line_count行换一个文件
        if (( counter % line_count == 0 )); then
            if [[ -n $output ]]; then
                exec 1>&3 3>&- # 关闭当前的输出文件
            fi
            mkdir -p ${DOOP_OUT}/init_${ID}/split_csv/${ID}_${fileNumber}/
            output="${DOOP_OUT}/init_${ID}/split_csv/${ID}_${fileNumber}/ListReadObjectClass.csv"
            exec 3>&1 1>$output # 打开新的输出文件
            ((fileNumber++))
        fi

        # 写入行
        echo "$line"
        ((counter++))
    done < "$input"

    # 关闭最后一个输出文件
    exec 1>&3 3>&-

	ListResult=$(cat $input|sed 's/^/\t\t/') 

    # 输出总行数和文件数
    echo -e "[+] $(print_time) Split:\n\t任务ID: ${ID}\n\t总待检测对象数量: $counter\n\t分割数: ${line_count}\n\t创建的文件数: $((fileNumber - 1))\n\t待检测对象:\n$ListResult"  | tee -a $CurrentLOG

    # 输出总行数和文件数
    ReturnCsvNumber=$((fileNumber - 1))
}

# 导出函数
export -f split_csv