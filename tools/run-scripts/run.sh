ID=example
###
 # @Author: fe1w0 xzasliuxinrong@gmail.com
 # @Date: 2023-10-30 13:23:12
 # @LastEditors: fe1w0 xzasliuxinrong@gmail.com
 # @LastEditTime: 2023-11-01 16:14:38
 # @FilePath: /tools/run-scripts/run.sh
 # @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
### 
# ID=cc_3_1

# original doop
DOOP_HOME=/Volumes/FE1W0/Project/SoftWareAnalysis/StaticAnalysis/doop/build/install/doop
BASE_DIR=/Users/fe1w0/Project/SoftWareAnalysis/DataSet
FuzzChainsPath=/Users/fe1w0/Project/SoftWareAnalysis/Dynamic/FuzzChains
JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-8.jdk/Contents/Home
JAVA_VERSION=java_8

# INPUT=org.apache.commons:commons-collections4:4.4
# INPUT=org.apache.commons:commons-collections4:4.4
# INPUT=org.apache.commons:commons-collections4:4.0
# INPUT=commons-collections:commons-collections:3.1
INPUT=$BASE_DIR/example/target/example.jar

# overwrite doop
bash $BASE_DIR/tools/overwrite.sh $DOOP_HOME
echo "[+] Finish: OverWrite"

export DOOP_PLATFORMS_LIB=/Volumes/FE1W0/Project/SoftWareAnalysis/StaticAnalysis/doop-benchmarks/
# bash ./analysis.sh $ID $INPUT $DOOP_HOME $BASE_DIR $FuzzChainsPath $JAVA_HOME $JAVA_VERSION

bash ./original.sh $ID $INPUT $DOOP_HOME $BASE_DIR $FuzzChainsPath $JAVA_HOME $JAVA_VERSION 8
echo "[+] Finish: Analysis"