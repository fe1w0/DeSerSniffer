#!/bin/bash
# author: fe1w0

# 函数：执行分析
run_analysis() {
    if [ $# -lt 7 ]; then
        echo "[-] $(print_time) Error: Not enough arguments" | tee -a $CurrentLOG
        echo " $(print_time) run_analysis [ID] [INPUT] [DOOP_HOME] [BASE_DIR] [FuzzChainsPath] [JAVA_HOME] [JAVA_VERSION] [JOBS (optional)]" | tee -a $CurrentLOG
        return 1
    fi

    local ID=$1
    local INPUT=$2
    local DOOP_HOME=$3
    local BASE_DIR=$4
    local FuzzChainsPath=$5
    local JAVA_HOME=$6
    local JAVA_VERSION=$7
    local JOBS=${8:-8}  # 如果没有提供第八个参数，则默认为8

    # 配置 JVM 环境
    echo "Export JVM ENV."
    PATH="$JAVA_HOME/bin:$PATH"
    CLASSPATH="./:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar"

    export JAVA_HOME
    export PATH
    export CLASSPATH

    # 配置 DOOP 地址
    export DOOP_HOME

    # 定义其他的变量和执行命令
    
    ######################
    # Parameters of doop #
    ######################

    # 利用 doop-benchmarks 导出 本地的 JRE 环境包
    # PLATFORM="--platform ${JAVA_VERSION} --use-local-java-platform ${JAVA_HOME}"
    PLATFORM="--platform ${JAVA_VERSION}"


    # ------------------------------------------
    # Todo 上下文敏感度有问题，需要提升 
    # ------------------------------------------
    # doop setup
    ANALYSIS="context-insensitive"

    OPEN_PROGRAM="--open-programs concrete-types"

    # souffle
    SOUFFLE_JOBS="--souffle-jobs ${JOBS}"
    SOUFFLE_MODE="--souffle-mode interpreted"
    SOUFFLE="${SOUFFLE_JOBS} ${SOUFFLE_MODE}"

    # extra logic
    EXTRA_LOGIC="--extra-logic $BASE_DIR/tools/custom-rules/analysis.dl"

    # Information-flow
    INFORMATION_FLOW="--information-flow minimal"

    # TIMEOUT
    TIMEOUT="--timeout 1440"

    # facts
    FACTS="--report-phantoms --fact-gen-cores ${JOBS} --generate-jimple --Xignore-factgen-errors"

    # Reflection
    ENABLE_REFLECTION="--light-reflection-glue"

    # app-only
    # APP_ONLY="--app-only"

    # --no-merges
    NoMerges="--no-merges"

    # CACHE
    # CACHE="--cache"

    # Xextra-facts
    ExtraFacts="--Xextra-facts ${DOOP_OUT}/init_${ID}/database/ListReadObjectClass.csv"

    # Log Level
    LOG="--level info"

    EXTRA_ARG="${PLATFORM} ${OPEN_PROGRAM} ${SOUFFLE} ${EXTRA_LOGIC} ${INFORMATION_FLOW} ${TIMEOUT} ${FACTS} ${ENABLE_REFLECTION} ${NoMerges} ${CACHE} ${ExtraFacts} ${LOG}"

    # 执行 doop 分析
    local CMD="${DOOP_HOME}/bin/doop -a $ANALYSIS -i ${INPUT} ${APP_ONLY} --id ${ID} ${EXTRA_ARG}"
    echo "[+] $(print_time) doop: $CMD" | tee -a $CurrentLOG
    echo "[+] $(print_time) doop: $CMD" >> $TmpLog
    eval "$CMD" >> $TmpLog

    echo "[+] $(print_time) Finish: run_analysis." | tee -a $CurrentLOG

	rm -rf ${DOOP_OUT}/${ID}/database/*.facts

	rm -rf ${DOOP_HOME}/${ID}/database/jimple

	echo "[+] $(print_time) Finish: clean up temporary data (facts and jimple files)." | tee -a $CurrentLOG
}

# 导出函数
export -f run_analysis
