#!/bin/bash
# author: fe1w0

# 导入文件
MAIN_DIR="$(dirname "$BASH_SOURCE")"

source $MAIN_DIR/utils/timer.sh
source $MAIN_DIR/utils/config.sh
source $MAIN_DIR/utils/split_csv.sh
source $MAIN_DIR/utils/list_class.sh
source $MAIN_DIR/utils/run_analysis.sh
source $MAIN_DIR/utils/stats.sh
source $MAIN_DIR/utils/print/monitor_doop_log.sh
source $MAIN_DIR/utils/config/extract_dependencies.sh

# 函数: 单个分析
single_analysis() {
    local ID=$1
    local INPUT=$2

    # 初始化
    timer config

    # 启动 List Object 脚本
	## Log 1.5.0-dev 为减少存储空间的占用，可以只保留 list_class 中的 facts 和 jimple 文件，并删除 sub_analysis 中 生成的 facts 和 jimple 文件
    timer list_class $ID $INPUT $DOOP_HOME $BASE_DIR $FuzzChainsPath $JAVA_HOME $JAVA_VERSION $JOBS
    
    # 检测 List 过程是否有问题
    monitor_doop_log $INPUT $ID

    if [ $? -eq 1 ]; then
        echo -e "[+] $(print_time) End:  $ID, $INPUT, $CurrentLOG" | tee -a $CurrentLOG
        return 1
    fi

    # 划分任务，得到子任务数量, 得到
    timer split_csv $ID $SplitLineNumber

    # 按序处理分析任, ReturnCsvNumber
    for (( sub_id=1; sub_id<=$ReturnCsvNumber; sub_id++))
    do
        SubID=${ID}_${sub_id}
		InitID="init_${ID}"
        timer run_analysis $SubID $INPUT $DOOP_HOME $BASE_DIR $FuzzChainsPath $JAVA_HOME $JAVA_VERSION $InitID $JOBS 
        monitor_doop_log $INPUT $SubID
		echo -e "[+] $(print_time) Finish Analysis:  $SubID" | tee -a $CurrentLOG
    done

    # 分析阶段
    for (( sub_id=1; sub_id<=$ReturnCsvNumber; sub_id++))
    do
        SubID=${ID}_${sub_id}
        stats $SubID
    done

    # 完成 single_analysis
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

# 导入配置
doop_config

TmpLog=/tmp/doop_$(date +%s).log
timer analysis $BASE_DIR/testjars/input.xml