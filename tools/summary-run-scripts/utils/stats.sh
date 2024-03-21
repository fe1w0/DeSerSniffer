#!/bin/bash
# author: fe1w0

# 函数：显示分析结果 (total leaks)，通过读取 input 文件的行数
function stats {
    local analysis_id=$1
    local input_file=${DOOP_OUT}/${analysis_id}/database/TaintedSinkMethod.csv
    if [[ -s "$input_file" ]]; then
        local total_leaks=$(wc -l < "$input_file")
        echo "[+] $(print_time) Result: ${analysis_id} - $total_leaks" | tee -a $CurrentLOG
    else
        echo "[+] $(print_time) Result: Not Result" | tee -a $CurrentLOG
    fi
}