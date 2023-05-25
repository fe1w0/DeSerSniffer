if [ $# -eq 0 ]; then 
    ID="test"
else
    ID=$1
fi

echo "ID: ${ID}"
BASE_DIR=/home/liuxr/Project/SoftwareAnalysis/DataSet/testjar
INPUT=$BASE_DIR/example.jar
DOOP_HOME=/home/liuxr/opt/doop

# Platform
PLATFORM="--platform java_8 --use-local-java-platform ${JAVA_HOME}/jre"

# doop setup
ANALYSIS="context-insensitive"

JIMPLE="--generate-jimple"

# OPEN PROGRAM
OPEN_PROGRAM="--open-programs concrete-types"

# souffle
SOUFFLE_JOBS="--souffle-jobs 30"
SOUFFLE_MODE="--souffle-mode interpreted"

# 避免 mac swp 过高
# --max-memory
# MaxMemory="--max-memory 4g"

# extra logic
# EXTRA_LOGIC="--extra-logic $BASE_DIR/rules/output.dl"
EXTRA_LOGIC="--extra-logic $BASE_DIR/rules/definition-information.dl"

# Information-flow
INFORMATION_FLOW="--information-flow minimal"

# cfg
CFG="--cfg"

# CHA
# CHA=""

# Reflection
ENABLE_REFLECTION="--reflection-high-soundness-mode"

# Proxy
ENABLE_PROXY="--reflection-dynamic-proxies"

# app-only
APP_ONLY="-app-only"

# Log Level
LOG="--level debug"

# Remember `-app-only` must be in front !
# Strange Error!
EXTRA_ARG="${PLATFORM} ${MaxMemory} ${OPEN_PROGRAM} ${CHA} ${SOUFFLE_MODE} ${SOUFFLE_JOBS} ${CFG} ${JIMPLE} ${EXTRA_LOGIC} ${INFORMATION_FLOW} ${LOG} ${ENABLE_REFLECTION} ${ENABLE_PROXY}"

cd $DOOP_HOME

CMD="${DOOP_HOME}/doop -a $ANALYSIS -i ${INPUT} ${APP_ONLY} --id ${ID} ${EXTRA_ARG}"
echo "doop: $CMD"
eval "${DOOP_HOME}/doop -a $ANALYSIS -i ${INPUT} ${APP_ONLY} --id ${ID} ${EXTRA_ARG}"

# 删除 cache
rm -rf ${DOOP_HOME}/cache/*