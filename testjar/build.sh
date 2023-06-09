BASE_DIR=/home/liuxr/Project/SoftwareAnalysis/DataSet/testjar
cd $BASE_DIR

rm -rf classes/*

# build class
# javac Taint.java -d classes
# javac Test.java -d classes
javac sources/*/*.java -d classes

# build jar
jar cvfm example.jar manifest.txt -C classes/ . 

echo "[+] Finish."