ID=example_debug_00

# original doop
# DOOP_HOME=/Users/fe1w0/Project/SoftWareAnalysis/StaticAnalysis/doop/build/install/doop
DOOP_HOME=/Volumes/FE1W0/Project/SoftWareAnalysis/StaticAnalysis/doop/build/install/doop
BASE_DIR=/Users/fe1w0/Project/SoftWareAnalysis/DataSet
FuzzChainsPath=/Users/fe1w0/Project/SoftWareAnalysis/Dynamic/FuzzChains
JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-8.jdk/Contents/Home
JAVA_VERSION=java_8
INPUT=$BASE_DIR/example/target/example.jar

# export DOOP_PLATFORMS_LIB=/Users/fe1w0/Project/SoftWareAnalysis/StaticAnalysis/doop-benchmarks
export DOOP_PLATFORMS_LIB=/Volumes/FE1W0/Project/SoftWareAnalysis/StaticAnalysis/doop-benchmarks/

# overwrite doop
bash $BASE_DIR/tools/overwrite_b.sh $DOOP_HOME
echo "[+] Finish: OverWrite"

# 注意没有 app-only
bash ./original_b.sh $ID $INPUT $DOOP_HOME $BASE_DIR $FuzzChainsPath $JAVA_HOME $JAVA_VERSION 8
echo "[+] Finish: Analysis"