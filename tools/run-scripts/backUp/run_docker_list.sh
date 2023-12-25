#!/bin/bash

# setup configuration
# INPUT=/data/DataSet-Software/example/target/example.jar
# INPUT=org.apache.commons:commons-collections4:4.4
# INPUT=org.apache.commons:commons-collections4:4.4
# INPUT=org.apache.commons:commons-collections4:4.0

# ID=commons_collections_commons_collections_3_1
# INPUT=commons-collections:commons-collections:3.1

ID=com_alibaba_nacos_nacos_client_2_3_0
INPUT=com.alibaba.nacos:nacos-client:2.3.0

DOOP_HOME=/doop/build/install/doop
BASE_DIR=/data/DataSet-Software/
FuzzChainsPath=/data/FuzzChains/
JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
JAVA_VERSION=java_8

# overwrite doop
bash $BASE_DIR/tools/overwrite_b.sh $DOOP_HOME
echo "[+] Finish: OverWrite"

# analysis
export DOOP_PLATFORMS_LIB=/doop-benchmarks/

# 初始化项目，获得直接的ReadObject函数()
bash ./list_readObject.sh $ID $INPUT $DOOP_HOME $BASE_DIR $FuzzChainsPath $JAVA_HOME $JAVA_VERSION 33
echo "[+] Finish: Analysis"
