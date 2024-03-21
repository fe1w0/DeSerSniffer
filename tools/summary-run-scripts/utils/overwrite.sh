#!/bin/bash
# author: fe1w0

# 定义帮助函数
function help() {
    echo "overwrite.sh [DOOP_HOME]"
    echo "\
    DOOP_HOME: doop 的地址"
}

# 定义覆盖函数
function overwrite() {
    local DOOP_HOME=$1

    if [ -z "$DOOP_HOME" ]; then
        echo "[!] $(print_time) Error: DOOP_HOME is not specified" | tee -a $CurrentLOG
        help
        return 1
    fi

    if [ -z "$BASE_DIR" ]; then
        echo "[!] $(print_time) Error: BASE_DIR is not specified" | tee -a $CurrentLOG
        help
        return 1
    fi

    # 进入脚本当前地址
    cd "$(dirname "$0")"

    # backup
    if [ ! -d $DOOP_HOME/souffle-logic-backup ] ; then
        cp -r $DOOP_HOME/souffle-logic $DOOP_HOME/souffle-logic-backup
    fi

    # overwrite
    overwrite_rules=("init.dl" "context-insensitive-analysis.dl" "rules.dl" "basic.dl" "entry-points.dl" "light-Class.dl" "light-reflection-glue.dl" "minimal-sources-and-sinks.dl" "app-only.dl", "native-reflection.dl", "implicit-reachable.dl")
    
    echo -e "\t[+] $(print_time) overwrite-rules:" | tee -a $CurrentLOG
    for overwrite_rule in "${overwrite_rules[@]}"
    do
        echo -e "\t\t $(print_time) overwrite-rule: $overwrite_rule" | tee -a $CurrentLOG
    done

    # 进行文件覆盖

	# 屏蔽 clinit 自动分析
	cp ${BASE_DIR}/tools/overwrite-rules/init.dl $DOOP_HOME/souffle-logic/main/init.dl

    # 屏蔽 Main
    cp ${BASE_DIR}/tools/overwrite-rules/basic.dl $DOOP_HOME/souffle-logic/basic/basic.dl

	# 使 TaintObjTransfer 可以 output
	cp ${BASE_DIR}/tools/overwrite-rules/rules.dl $DOOP_HOME/souffle-logic/addons/information-flow/rules.dl

	# 屏蔽 ContextResponse
	cp ${BASE_DIR}/tools/overwrite-rules/context-insensitive-analysis.dl  $DOOP_HOME/souffle-logic/analyses/context-insensitive/analysis.dl

    # 设置入口点
    cp ${BASE_DIR}/tools/overwrite-rules/entry-points_b.dl $DOOP_HOME/souffle-logic/addons/open-programs/entry-points.dl

    # 反射
    cp ${BASE_DIR}/tools/overwrite-rules/light-Class.dl $DOOP_HOME/souffle-logic/main/reflection/light-Class.dl
    cp ${BASE_DIR}/tools/overwrite-rules/light-reflection-glue.dl $DOOP_HOME/souffle-logic/main/reflection/light-reflection-glue.dl

    # 优化分析速度
    cp ${BASE_DIR}/tools/overwrite-rules/minimal-sources-and-sinks.dl $DOOP_HOME/souffle-logic/addons/information-flow/minimal-sources-and-sinks.dl

    # 优化分析速度
    cp ${BASE_DIR}/tools/overwrite-rules/native-reflection.dl $DOOP_HOME/souffle-logic/main/reflection/native-reflection.dl
    cp ${BASE_DIR}/tools/overwrite-rules/implicit-reachable.dl $DOOP_HOME/souffle-logic/main/implicit-reachable.dl
}

# 导出函数
export -f overwrite