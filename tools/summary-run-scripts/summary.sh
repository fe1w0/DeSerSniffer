#!/bin/bash
# author: fe1w0

# 导入文件
MAIN_DIR="$(dirname "$BASH_SOURCE")"

source $MAIN_DIR/utils/timer.sh
source $MAIN_DIR/utils/config.sh
source $MAIN_DIR/utils/split_csv.sh
source $MAIN_DIR/utils/list_class.sh
source $MAIN_DIR/utils/run_analysis.sh
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

TmpLog=/tmp/doop_$(date +%s).log

echo "[+] TmpLog: ${TmpLog}"

# single_analysis summary_org_clojure_clojure_1_12_0_alpha5 org.clojure:clojure:1.12.0-alpha5 org_clojure_clojure_1_12_0_alpha5

single_analysis summary_com_alibaba_nacos_nacos_client_2_3_0 /home/liuxr/.ivy2/cache/com.alibaba.nacos/nacos-client/jars/nacos-client-2.3.0.jar