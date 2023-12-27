#!/bin/bash
# author: fe1w0

# 导入文件
source utils/timer.sh
source utils/config.sh
source utils/split_csv.sh
source utils/list_class.sh
source utils/run_analysis.sh
source utils/stats.sh
source utils/print/monitor_doop_log.sh
source utils/config/extract_dependencies.sh

# 函数: 单个分析
single_analysis() {
    local ID=$1
    local INPUT=$2

    # 初始化
    timer config

    # 启动 List Object 脚本
    timer list_class $ID $INPUT $DOOP_HOME $BASE_DIR $FuzzChainsPath $JAVA_HOME $JAVA_VERSION $JOBS >> $TmpLog
    
    # 检测 DOOP 过程是否有问题
    monitor_doop_log $INPUT $ID

    # 划分任务，得到子任务数量, 得到
    timer split_csv $ID $SplitLineNumber

    # 按序处理分析任, ReturnCsvNumber
    for (( sub_id=1; sub_id<=$ReturnCsvNumber; sub_id++))
    do
        SubID=${ID}_${sub_id}
        timer run_analysis $SubID $INPUT $DOOP_HOME $BASE_DIR $FuzzChainsPath $JAVA_HOME $JAVA_VERSION $JOBS >> $TmpLog
    done

    # 分析阶段
    for (( sub_id=1; sub_id<=$ReturnCsvNumber; sub_id++))
    do
        SubID=${ID}_${sub_id}
        stats $SubID
    done
    
    echo -e "[+] $(print_time) End:  $ID, $INPUT, $CurrentLOG" | tee -a $CurrentLOG
}

# 函数: 分析
analysis() {
    local DependenciesFile=$1
    
    echo "[+] TmpLog: ${TmpLog}"
    # 设置检测项目
    extract_dependencies $DependenciesFile

    for i in "${!IDS[@]}"; do
        timer single_analysis "${IDS[i]}" "${INPUTS[i]}"
    done
}

TmpLog=/tmp/doop_$(date +%s).log
timer analysis /home/zhangying/Project/SoftwareAnalysis/DataSet-Software/testjars/input.xml