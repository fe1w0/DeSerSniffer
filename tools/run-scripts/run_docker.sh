#!/bin/bash

# setup configuration
ID=demo
# INPUT=/data/DataSet-Software/example/target/example.jar
# INPUT=org.apache.commons:commons-collections4:4.4
# INPUT=org.apache.commons:commons-collections4:4.4
# INPUT=org.apache.commons:commons-collections4:4.0
INPUT=commons-collections:commons-collections:3.1

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
bash ./original_b.sh $ID $INPUT $DOOP_HOME $BASE_DIR $FuzzChainsPath $JAVA_HOME $JAVA_VERSION 30
