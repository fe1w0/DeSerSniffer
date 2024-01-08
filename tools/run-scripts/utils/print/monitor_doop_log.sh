#!/bin/bash
# author: fe1w0

# 函数：监控 DOOP 日志文件
monitor_doop_log() {
    local INPUT=$1
    local ID=$2
    local log_file="${DOOP_HOME}/build/logs/doop.log"  # 指定日志文件的路径

    # 检查日志文件是否存在
    if [ ! -f "$log_file" ]; then
        echo "[!] $(print_time) Error: Log file does not exist." | tee -a $CurrentLOG
        return 1
    fi

    # 搜索日志文件中的错误模式

    ## 失败的 INPUT
    matched_results=$(grep "ERROR: Doop error .* ${INPUT}" "${log_file}")
    if [ -n "$matched_results" ]; then
        echo "[+] $(print_time) Monitoring DOOP Log for Errors:" | tee -a $CurrentLOG
        echo -e "\t $(print_time) Error ${INPUT}:\n${matched_results}" | tee -a $CurrentLOG
        # 失败的 INPUT 还是 return 以维持批量分析的稳定性
        return 1
    fi

    ## 内存爆炸问题
    matched_results=$(grep "ERROR: Command exited with non-zero status:" "${log_file}" -A 1 |grep "\b$ID\b")
    if [ -n "$matched_results" ]; then
        echo "[+] $(print_time) Monitoring DOOP Log for Errors:" | tee -a $CurrentLOG
        echo -e "\t $(print_time) Error ${ID}:\n${matched_results}" | tee -a $CurrentLOG
        return 2
    fi
}

export -f monitor_doop_log