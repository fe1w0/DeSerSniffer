#!/bin/bash

ID=$1
INPUT=$2
DOOP_HOME=$3
BASE_DIR=$4
FuzzChainsPath=$5
JAVA_HOME=$6
JAVA_VERSION=$7
# JRE_PLATFORM=$8

function help() {
    echo "analysis.sh [ID] [INPUT] [DOOP_HOME] [BASE_DIR] [FuzzChainsPath] [JAVA_HOME] [JAVA_VERSION]"
    echo "\
    ID: doop 分析的 ID值
    INPUT: 需要分析的Jar文件
    DOOP_HOME: doop 的地址
    BASE_DIR: 包含自定义的 rules
    FuzzChainsPath: FuzzChains的地址
    JAVA_HOME: java 的 home 地址
    JAVA_VERSION: 需要分析的版本，需要注意，要与JAVA_HOME版本一致，如 java_8
    "
    # JRE_PLATFORM: 导入 JRE_PLATFORM，需要分析的JAVA版本
}

if [[ $# -lt 7 ]]; then
    echo "Error: Not enough arguments"
    help
    exit 1
fi


# echo "\tCurrent_ENV:\tJRE_PLATFORM\t${JRE_PLATFORM}"
# echo "\tCurrent_ENV:\tJRE_PLATFORM\t${JRE_PLATFORM}"

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
PLATFORM="--platform ${JAVA_VERSION} --use-local-java-platform ${JAVA_HOME}"

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
SOUFFLE_JOBS="--souffle-jobs 30"
SOUFFLE_MODE="--souffle-mode interpreted"

# 避免 mac swp 过高
# --max-memory
# MaxMemory="--max-memory 32g"

# extra logic
# EXTRA_LOGIC="--extra-logic $BASE_DIR/rules/output.dl"
EXTRA_LOGIC="--extra-logic $BASE_DIR/tools/custom-rules/definition-information.dl"

# Information-flow
INFORMATION_FLOW="--information-flow minimal"

# cfg
# CFG="--cfg"

# facts
# FACTS="--Xignore-factgen-errors"
FACTS="--Xignore-wrong-staticness  --report-phantoms"

# CHA
# CHA=""

# Reflection
# --distinguish-reflection-only-string-constants --distinguish-all-string-constants 选项互相排斥
# --reflection-classic
#
# ENABLE_REFLECTION="--reflection-classic"
ENABLE_REFLECTION="--light-reflection-glue"

# Proxy
# ENABLE_PROXY="--reflection-dynamic-proxies"

# app-only
APP_ONLY="-app-only"

# dependency:copy-dependencies -DoutputDirectory=lib
# LIBRARIES="-l ${BASE_DIR}/lib"

# Log Level
LOG="--level debug"

# CACHE
# CACHE="--cache"

# Output SARIF results
SARIF="--sarif"

# Remember `-app-only` must be in front !
# Strange Error!
EXTRA_ARG="${CACHE} ${EXTRA_ENTRY_POINTS} ${FACTS} ${PLATFORM} ${MaxMemory} ${OPEN_PROGRAM} ${CHA} ${SOUFFLE_MODE} ${SOUFFLE_JOBS} ${CFG} ${JIMPLE} ${EXTRA_LOGIC} ${INFORMATION_FLOW} ${LOG} ${ENABLE_REFLECTION} ${ENABLE_PROXY} ${SARIF}"

cd $DOOP_HOME

CMD="${DOOP_HOME}/bin/doop -a $ANALYSIS -i ${INPUT} ${APP_ONLY} --id ${ID} ${EXTRA_ARG}"
echo "doop: $CMD"
eval "${DOOP_HOME}/bin/doop -a $ANALYSIS -i ${INPUT} ${APP_ONLY} --id ${ID} ${EXTRA_ARG}"

echo "[+] Finish."
# 删除 cache
# rm -rf ${DOOP_HOME}/cache/*

# 分析:
# 1. PropertyTree.csv
# 2. 转移 ChainPathsOutput.csv

ChainPathsFilePath="${DOOP_HOME}/out/${ID}/database/ChainPathsOutput.csv"
PropertyTreeFilePath="${DOOP_HOME}/out/${ID}/database/PropertyTree.csv"

OutputInstrumentationMethodPath="${DOOP_HOME}/out/${ID}/database/OutputInstrumentationMethod.csv"

echo "[+] ChainPathsFilePath:\t ${ChainPathsFilePath}"
echo "[+] PropertyTreeFilePath:\t ${PropertyTreeFilePath}"


echo "[+] Copy: ${ChainPathsFilePath} -> ${FuzzChainsPath}/DataSet/paths.csv"
cp "${ChainPathsFilePath}" "${FuzzChainsPath}/DataSet/paths.csv"


echo "[+] Copy: ${PropertyTreeFilePath} -> ${BASE_DIR}/tools/generatePT/PropertyTree.csv"
cp "${PropertyTreeFilePath}" "${BASE_DIR}/tools/generatePT/PropertyTree.csv"

echo "[+] Copy: ${OutputInstrumentationMethodPath} -> ${FuzzChainsPath}/DataSet/sinks.csv"
cp "${OutputInstrumentationMethodPath}" "${FuzzChainsPath}/DataSet/sinks.csv"

echo "[+] Finish"