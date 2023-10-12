machine_name=$(hostname)
# 判断当前机器名是否为 fe1w0deMacBook-Air.local
if [ "$machine_name" = "fe1w0deMacBook-Air.local" ]; then
    BASE_DIR=/Users/fe1w0/Project/SoftWareAnalysis/DataSet/example/
    TARGETPATH=/Users/fe1w0/Project/SoftWareAnalysis/Dynamic/FuzzChains/DataSet/targets
else
    BASE_DIR=/home/fe1w0/SoftwareAnalysis/DataSet/example
    TARGETPATH=/home/fe1w0/SoftwareAnalysis/DynamicAnalysis/FuzzChains/DataSet/targets
fi

cd $BASE_DIR

# build class
mvn clean package -DskipTests=true

rm -rf ${TARGETPATH}/*

cp ./target/example.jar ${TARGETPATH}/xyz-xzaslxr-1.0.jar

cp ./target/example.jar ../testjars/

echo "[+] Finish."