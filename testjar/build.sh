
BASE_DIR=/Users/fe1w0/Project/SoftWareAnalysis/DataSet/testjar
cd $BASE_DIR

rm -rf classes/*

# build class
javac Test.java -d classes

# build jar
jar cvfm example.jar manifest.txt -C classes/ . 

echo "[+] Finish."