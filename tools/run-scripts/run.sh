ID=cc_3_1

# INPUT=/Users/fe1w0/Project/SoftWareAnalysis/DataSet/example/target/example.jar
# INPUT=org.apache.commons:commons-collections4:4.4
# INPUT=org.apache.commons:commons-collections4:4.4
# INPUT=org.apache.commons:commons-collections4:4.0
INPUT=commons-collections:commons-collections:3.1

# modified doop
# DOOP_HOME=/Volumes/FE1W0/Project/SoftWareAnalysis/StaticAnalysis/doop/build/install/doop

# original doop
DOOP_HOME=/Volumes/FE1W0/Project/SoftWareAnalysis/StaticAnalysis/doop/build/install/doop

BASE_DIR=/Users/fe1w0/Project/SoftWareAnalysis/DataSet
FuzzChainsPath=/Users/fe1w0/Project/SoftWareAnalysis/Dynamic/FuzzChains
JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-8.jdk/Contents/Home
JAVA_VERSION=java_8

# overwrite doop
bash $BASE_DIR/tools/overwrite.sh $DOOP_HOME
echo "[+] Finish: OverWrite"

export DOOP_PLATFORMS_LIB=/Volumes/FE1W0/Project/SoftWareAnalysis/StaticAnalysis/doop-benchmarks/
# bash ./analysis.sh $ID $INPUT $DOOP_HOME $BASE_DIR $FuzzChainsPath $JAVA_HOME $JAVA_VERSION

bash ./original.sh $ID $INPUT $DOOP_HOME $BASE_DIR $FuzzChainsPath $JAVA_HOME $JAVA_VERSION 8
echo "[+] Finish: Analysis"