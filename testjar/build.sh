BASE_DIR=/home/liuxr/Project/SoftwareAnalysis/DataSet/testjar
#BASE_DIR=/Users/fe1w0/Project/SoftWareAnalysis/DataSet/testjar
BASE_DIR=/home/fe1w0/SoftwareAnalysis/DataSet/testjar
cd $BASE_DIR

rm -rf classes/*

# build class
# javac Taint.java -d classes
# javac Test.java -d classes
javac sources/*/*.java -d classes

# build jar
jar cvfm example.jar manifest.txt -C classes/ . 

# copy exmaple.jar to FuzzChains
cp ./example.jar /home/fe1w0/SoftwareAnalysis/DynamicAnalysis/FuzzChains/DataSet/target/
# cp ./example.jar /Users/fe1w0/Project/SoftWareAnalysis/Dynamic/FuzzChains/DataSet/target/

echo "[+] Finish."