#!/bin/bash
# author: fe1w0

# 导入文件
MAIN_DIR="$(dirname "$BASH_SOURCE")"

source $MAIN_DIR/utils/timer.sh
source $MAIN_DIR/utils/config.sh
source $MAIN_DIR/utils/run_summary.sh
source $MAIN_DIR/utils/stats.sh
source $MAIN_DIR/utils/print/monitor_doop_log.sh
source $MAIN_DIR/utils/config/extract_dependencies.sh

# 函数: 单个分析
single_analysis() {
	local ID=$1
    local INPUT=$2

    # 初始化
    timer config

	timer run_summary $ID $INPUT $DOOP_HOME $BASE_DIR $FuzzChainsPath $JAVA_HOME $JAVA_VERSION $JOBS
	
    # 分析阶段
    monitor_doop_log $INPUT $ID
    stats $ID

    # 完成 analysis
    echo -e "[+] $(print_time) End:  $ID $INPUT $CurrentLOG" | tee -a $CurrentLOG
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