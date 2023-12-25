# 临时需求:
# 清除所有的Cache和Out结果
DOOP_HOME=/home/liuxr/opt/doop/build/install/doop

echo "[+] Delete DataSet in out and cache floders."
rm -rf $DOOP_HOME/out/*
rm -rf $DOOP_HOME/cache/*