ID=demo
INPUT=/data/DataSet-Software/example/target/example.jar
# INPUT=org.apache.commons:commons-collections4:4.4
# INPUT=org.apache.commons:commons-collections4:4.4
# INPUT=org.apache.commons:commons-collections4:4.0
# INPUT=commons-collections:commons-collections:3.1

# modified doop
# DOOP_HOME=/Volumes/FE1W0/Project/SoftWareAnalysis/StaticAnalysis/doop/build/install/doop

# original doop
DOOP_HOME=/doop/build/install/doop

BASE_DIR=/data/DataSet-Software/
FuzzChainsPath=/data/FuzzChains/
JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java
JAVA_VERSION=java_8

export DOOP_PLATFORMS_LIB=/doop-benchmarks/
# bash ./analysis.sh $ID $INPUT $DOOP_HOME $BASE_DIR $FuzzChainsPath $JAVA_HOME $JAVA_VERSION

bash ./original.sh $ID $INPUT $DOOP_HOME $BASE_DIR $FuzzChainsPath $JAVA_HOME $JAVA_VERSION