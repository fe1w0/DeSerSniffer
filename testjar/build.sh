
machine_name=$(hostname)
# 判断当前机器名是否为 fe1w0deMacBook-Air.local
if [ "$machine_name" = "fe1w0deMacBook-Air.local" ]; then
    BASE_DIR=/Users/fe1w0/Project/SoftWareAnalysis/DataSet/testjar
    TARGETPATH=/Users/fe1w0/Project/SoftWareAnalysis/Dynamic/FuzzChains/otherLib/
else
    BASE_DIR=/home/fe1w0/SoftwareAnalysis/DataSet/testjar
    TARGETPATH=/home/fe1w0/SoftwareAnalysis/DynamicAnalysis/FuzzChains/otherLib/
fi

cd $BASE_DIR

rm -rf classes/*

# build class
javac sources/*/*.java -d classes

# build jar
jar cvfm example.jar manifest.txt -C classes/ . 

# copy exmaple.jar to FuzzChains

rm -rf ${TARGETPATH}/*

cd ${BASE_DIR}

mkdir -p ${TARGETPATH}/xyz/xzaslxr/Example/1.0/

cp ./example.jar ${TARGETPATH}/xyz/xzaslxr/Example/1.0/Example-1.0.jar

echo "[+] Finish."