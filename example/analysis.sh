if [ $# -eq 0 ]; then
    ID="example"
else
    ID=$1
fi

echo "ID: ${ID}"

machine_name=$(hostname)
# 判断当前机器名是否为 fe1w0deMacBook-Air.local
if [ "$machine_name" = "fe1w0deMacBook-Air.local" ]; then
    BASE_DIR=/Users/fe1w0/Project/SoftWareAnalysis/DataSet/
    DOOP_HOME=/Users/fe1w0/Project/SoftWareAnalysis/StaticAnalysis/doop

    export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-8.jdk/Contents/Home
    PATH="$JAVA_HOME/bin:$PATH"
    CLASSPATH="./:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar"

    FuzzChainsPath=/Users/fe1w0/Project/SoftWareAnalysis/Dynamic/FuzzChains/

    export JAVA_HOME
    export PATH
    export CLASSPATH

    java -version

    export DOOP_HOME=/Users/fe1w0/Project/SoftWareAnalysis/StaticAnalysis/doop/build/install/doop


elif [ "$machine_name" = "other" ]; then
    BASE_DIR=/home/fe1w0/SoftwareAnalysis/DataSet/testjar

fi


INPUT=$BASE_DIR/testjars/example.jar


######################
# Parameters of doop #
######################

# Platform
PLATFORM="--platform java_8 --use-local-java-platform ${JAVA_HOME}/jre"

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