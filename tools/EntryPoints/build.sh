BASE_DIR=/Users/fe1w0/Project/SoftWareAnalysis/DataSet/tools/EntryPoints
cd $BASE_DIR

rm -rf classes/*

# build class
javac sources/*.java -d classes

# build jar
jar cvfm entry-points.jar manifest.txt -C classes/ . 

echo "[+] Finish."