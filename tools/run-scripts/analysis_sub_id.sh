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
    local SubID=$1
    local INPUT=$2
	local InitID="init_$3"
	
    # 初始化
    timer config

	timer run_analysis $SubID $INPUT $DOOP_HOME $BASE_DIR $FuzzChainsPath $JAVA_HOME $JAVA_VERSION $InitID $JOBS
	monitor_doop_log $INPUT $SubID

    # 分析阶段
	stats $SubID

    # 完成 analysis
    echo -e "[+] $(print_time) End:  $SubID $INPUT $CurrentLOG" | tee -a $CurrentLOG
}

TmpLog=/tmp/doop_$(date +%s).log

echo "[+] TmpLog: ${TmpLog}"

single_analysis org_clojure_clojure_1_12_0_alpha5_1 org.clojure:clojure:1.12.0-alpha5 org_clojure_clojure_1_12_0_alpha5
# single_analysis org_clojure_clojure_1_12_0_alpha5_3 org.clojure:clojure:1.12.0-alpha5