#!/bin/bash
# author: fe1w0

# 函数：计时器
timer() {
    local start=$(date +%s%N) # 记录开始时间（纳秒）
    "$@"                      # 执行传入的命令或函数，包括其参数
    local end=$(date +%s%N)   # 记录结束时间（纳秒）
    local duration=$((end - start))
    echo -e "[-] $(print_time) Log:\t${@}"  | tee -a $CurrentLOG
    echo -e "\t执行时间: $((duration / 1000000000)) s" | tee -a $CurrentLOG # 输出持续时间（毫秒）
}

print_time() {
    echo "$(date +"%Y-%m-%d %H:%M:%S")"
}

export -f timer
export -f print_time