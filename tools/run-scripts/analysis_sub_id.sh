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
    local SubID=$1
	local ID=$1
    local INPUT=$2

    # 初始化
    timer config

	timer run_analysis $SubID $INPUT $DOOP_HOME $BASE_DIR $FuzzChainsPath $JAVA_HOME $JAVA_VERSION $JOBS >> $TmpLog
	monitor_doop_log $INPUT $SubID

    # 分析阶段
	stats $SubID

    # 完成 analysis
    echo -e "[+] $(print_time) End:  $SubID, $INPUT, $CurrentLOG" | tee -a $CurrentLOG
}

TmpLog=/tmp/doop_$(date +%s).log

echo "[+] TmpLog: ${TmpLog}"

single_analysis com_alibaba_nacos_nacos_client_2_3_0_5 com.alibaba.nacos:nacos-client:2.3.0