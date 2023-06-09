if [ $# -eq 0 ]; then 
    ID="test"
else
    ID=$1
fi

echo "ID: ${ID}"
BASE_DIR=/home/liuxr/Project/SoftwareAnalysis/DataSet/

# INPUT
YSOSERIAL=/home/liuxr/Project/SoftwareAnalysis/DataSet/ysoserial/target/ysoserial-0.0.6-SNAPSHOT.jar

INPUT=$BASE_DIR/testjar/example.jar
# INPUT=${YSOSERIAL}

DOOP_HOME=/home/liuxr/opt/doop

# Platform
PLATFORM="--platform java_8 --use-local-java-platform ${JAVA_HOME}/jre"

# doop setup
ANALYSIS="context-insensitive"
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
LIBRARIES="-l /home/liuxr/Project/SoftwareAnalysis/DataSet/testjar/lib"

# Log Level
LOG="--level debug"

# CACHE
CACHE="--cache"

# Remember `-app-only` must be in front !
# Strange Error!
EXTRA_ARG="${CACHE} ${EXTRA_ENTRY_POINTS} ${FACTS} ${PLATFORM} ${MaxMemory} ${OPEN_PROGRAM} ${CHA} ${SOUFFLE_MODE} ${SOUFFLE_JOBS} ${CFG} ${JIMPLE} ${EXTRA_LOGIC} ${INFORMATION_FLOW} ${LOG} ${ENABLE_REFLECTION} ${ENABLE_PROXY}"

cd $DOOP_HOME

CMD="${DOOP_HOME}/doop -a $ANALYSIS -i ${INPUT} ${LIBRARIES} ${APP_ONLY} --id ${ID} ${EXTRA_ARG}"
echo "doop: $CMD"
eval "${DOOP_HOME}/doop -a $ANALYSIS -i ${INPUT} ${LIBRARIES} ${APP_ONLY} --id ${ID} ${EXTRA_ARG}"

# 删除 cache
# rm -rf ${DOOP_HOME}/cache/*