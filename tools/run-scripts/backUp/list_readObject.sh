#!/bin/bash

ID="init_${1}"
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

# ------------------------------------------
# Todo 上下文敏感度有问题，需要提升 
# ------------------------------------------
# doop setup
ANALYSIS="context-insensitive"
# 分析精度-拓展目标🎯
# ANALYSIS="1-object-sensitive"

JIMPLE="--generate-jimple"

# OPEN PROGRAM 动态类型: 会根据 ActualParam 中的类型，来补充PointsTo，但实际上也会引入大量Merge信息，尤其是 context-insensitive 和 存在 
OPEN_PROGRAM="--open-programs concrete-types"

# souffle
SOUFFLE_JOBS="--souffle-jobs ${JOBS}"
SOUFFLE_MODE="--souffle-mode interpreted"

# extra logic
EXTRA_LOGIC="--extra-logic $BASE_DIR/tools/custom-rules/init/list_readObject.dl"

# TIMEOUT
TIMEOUT="--timeout 1440"

# facts
# FACTS="--Xignore-factgen-errors --Xignore-wrong-staticness"
FACTS="--report-phantoms --fact-gen-cores ${JOBS}"

# app-only
APP_ONLY="--app-only"

# Log Level
# LOG="--level INFO"

# --no-merges
NoMerges="--no-merges"

# CACHE
CACHE="--cache"
# CACHE="--dont-cache-facts"

# Only Facts, Only generate facts and exit.
# OnlyFacts="--facts-only"

# Xignore-factgen-errors
IgnoreErrors="--Xignore-factgen-errors"

EXTRA_ARG="${OnlyFacts} ${IgnoreErrors} ${EXTRA_ENTRY_POINTS} ${DATA_FLOW} ${EXCLUDE_IMPLICITLY_REACHABLE_CODE} ${TIMEOUT} ${NoMerges} ${FACTS} ${PLATFORM} ${MaxMemory} ${OPEN_PROGRAM} ${CHA} ${SOUFFLE_MODE} ${SOUFFLE_JOBS} ${SOUFFLE_PROFILE} ${CFG} ${JIMPLE} ${EXTRA_LOGIC} ${INFORMATION_FLOW} ${LOG} ${ENABLE_REFLECTION} ${ENABLE_PROXY} ${SARIF}"

cd $DOOP_HOME

CMD="${DOOP_HOME}/bin/doop -a $ANALYSIS -i ${INPUT} ${APP_ONLY} --id ${ID} ${CACHE} ${EXTRA_ARG}"
echo "doop: $CMD"
eval "${DOOP_HOME}/bin/doop -a $ANALYSIS -i ${INPUT} ${APP_ONLY} --id ${ID} ${CACHE} ${EXTRA_ARG}"
