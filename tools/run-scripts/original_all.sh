#!/bin/bash

ID=$1
INPUT=$2
DOOP_HOME=$3
BASE_DIR=$4
FuzzChainsPath=$5
JAVA_HOME=$6
JAVA_VERSION=$7


function help() {
    echo "analysis.sh [ID] [INPUT] [DOOP_HOME] [BASE_DIR] [FuzzChainsPath] [JAVA_HOME] [JAVA_VERSION] [JOBS]"
    echo "\
    ID: doop 分析的 ID值
    INPUT: 需要分析的Jar文件
    DOOP_HOME: doop 的地址
    BASE_DIR: 包含自定义的 rules
    FuzzChainsPath: FuzzChains的地址
    JAVA_HOME: java 的 home 地址
    JAVA_VERSION: 需要分析的版本，需要注意，要与JAVA_HOME版本一致，如 java_8
    JOBS: Souffle 平行进程数量
    "
}

if [ $# -lt 7 ]; then
    echo "Error: Not enough arguments"
    help
    exit 1
elif [ $# == 7 ]; then
    JOBS=8
elif [ $# == 8 ]; then
    JOBS=$8
fi

# 配置 JVM 环境
echo "Export JVM ENV."
PATH="$JAVA_HOME/bin:$PATH"
CLASSPATH="./:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar"

export JAVA_HOME
export PATH
export CLASSPATH

# 配置 DOOP 地址
export DOOP_HOME


######################
# Parameters of doop #
######################

# 利用 doop-benchmarks 导出 本地的 JRE 环境包
# PLATFORM="--platform ${JAVA_VERSION} --use-local-java-platform ${JAVA_HOME}"
PLATFORM="--platform ${JAVA_VERSION}"

# doop setup
ANALYSIS="context-insensitive"

# ------------------------------------------
# Todo 上下文敏感度有问题，需要提升 
# ------------------------------------------
# ANALYSIS="2-object-sensitive+heap"

JIMPLE="--generate-jimple"

# OPEN PROGRAM
OPEN_PROGRAM="--open-programs concrete-types"

# souffle
SOUFFLE_JOBS="--souffle-jobs ${JOBS}"
SOUFFLE_MODE="--souffle-mode interpreted"
SOUFFLE_PROFILE="--souffle-profile"

# 避免 mac swp 过高
# --max-memory
# MaxMemory="--max-memory 8g"

# extra logic
EXTRA_LOGIC="--extra-logic $BASE_DIR/tools/custom-rules/app-only.dl"

# Information-flow
INFORMATION_FLOW="--information-flow minimal"

# TIMEOUT
TIMEOUT="--timeout 1440"

# cfg
# CFG="--cfg"

# facts
# FACTS="--Xignore-factgen-errors --Xignore-wrong-staticness"
FACTS="--report-phantoms --fact-gen-cores ${JOBS}"

# Reflection
# --distinguish-reflection-only-string-constants --distinguish-all-string-constants 选项互相排斥
# --reflection-classic
# ENABLE_REFLECTION="--reflection-classic"
ENABLE_REFLECTION="--light-reflection-glue"

# Proxy
# ENABLE_PROXY="--reflection-dynamic-proxies"

# app-only
# APP_ONLY="--app-only"

# Log Level
LOG="--level debug"

# --no-merges
NoMerges="--no-merges"

# CACHE
CACHE="--cache"
# CACHE="--dont-cache-facts"

# Output SARIF results
SARIF="--sarif"

# Strange Error!
EXTRA_ARG="${EXTRA_ENTRY_POINTS} ${TIMEOUT} ${NoMerges} ${FACTS} ${PLATFORM} ${MaxMemory} ${OPEN_PROGRAM} ${CHA} ${SOUFFLE_MODE} ${SOUFFLE_JOBS} ${SOUFFLE_PROFILE} ${CFG} ${JIMPLE} ${EXTRA_LOGIC} ${INFORMATION_FLOW} ${LOG} ${ENABLE_REFLECTION} ${ENABLE_PROXY} ${SARIF}"

cd $DOOP_HOME

CMD="${DOOP_HOME}/bin/doop -a $ANALYSIS -i ${INPUT} ${APP_ONLY} --id ${ID} ${CACHE} ${EXTRA_ARG}"
echo "doop: $CMD"
eval "${DOOP_HOME}/bin/doop -a $ANALYSIS -i ${INPUT} ${APP_ONLY} --id ${ID} ${CACHE} ${EXTRA_ARG}"

echo "[+] Finish."