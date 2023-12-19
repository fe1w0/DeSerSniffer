#!/bin/bash

# setup configuration
ID=cc_3_1

DOOP_HOME=/home/liuxr/opt/doop/build/install/doop
BASE_DIR=/home/liuxr/Project/SoftwareAnalysis/DataSet-Software
FuzzChainsPath=/home/liuxr/Project/SoftwareAnalysis/FuzzChains/
JAVA_HOME=/home/liuxr/opt/jdk1.8.0_341/
JAVA_VERSION=java_8

# INPUT=org.apache.commons:commons-collections4:4.4
# INPUT=org.apache.commons:commons-collections4:4.4
# INPUT=org.apache.commons:commons-collections4:4.0
INPUT=commons-collections:commons-collections:3.1
# INPUT=/home/liuxr/Project/SoftwareAnalysis/DataSet-Software/example/target/example.jar

export DOOP_PLATFORMS_LIB=/home/liuxr/opt/doop-benchmarks/

# overwrite doop
bash $BASE_DIR/tools/overwrite_b.sh $DOOP_HOME
echo "[+] Finish: OverWrite"

# 初始化项目，获得直接的ReadObject函数()
bash ./list_readObject.sh $ID $INPUT $DOOP_HOME $BASE_DIR $FuzzChainsPath $JAVA_HOME $JAVA_VERSION 30
echo "[+] Finish: Analysis"