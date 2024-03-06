#!/bin/bash
# author: fe1w0

# 导入文件
import_dir="$(dirname "$BASH_SOURCE")"

# 函数: 初始化
init_database() {
	# 使用局部变量存储参数
	
    local TmpDataPath=$1

	## $DOOP_RESULT/neo4j-data/import
	## $DOOP_RESULT/neo4j-data <-> /tmp
    local DataPath=$2

	mkdir -p $DataPath
	mkdir -p $DataPath/../conf
	
	# 修改权限
	local CONFIG_FILE=$DataPath/../conf/neo4j.conf

	# 修改 Neo4j 的 配置文件
	tee "$CONFIG_FILE" > /dev/null <<EOF
dbms.tx_log.rotation.retention_policy=100M size
dbms.ssl.policy.bolt.enabled=false
dbms.memory.pagecache.size=5120M
dbms.connector.bolt.listen_address=0.0.0.0:7687
dbms.connector.http.listen_address=0.0.0.0:7474
dbms.directories.import=import
dbms.directories.logs=/logs
dbms.security.auth_enabled=false
EOF

	cp $import_dir/init-db.sh $DataPath/
	chmod +x $DataPath/init-db.sh
}

# 函数: 导入数据到neo4j数据库
import_neo4j_data() {
    # 使用局部变量存储参数
    local TmpDataPath=$1
    local DataPath=$2
	local CONFIG_FILE=$DataPath/../conf/neo4j.conf

	# #初始化配置文件和文件夹权限
	# init_database $TmpDataPath $DataPath

	# 为Nodes.csv文件创建带标题的csv
	title_row="name:ID(Node)\t:LABEL"
	csv_file=$TmpDataPath/Nodes.csv
	target_csv_file="${DataPath}/node.csv"
	echo -e "$title_row\n$(cat $csv_file)" > $target_csv_file

	# 为CallGraph.csv文件创建带标题的csv
	title_row_callgraph=":START_ID(Node)\t:END_ID(Node)\t:TYPE"
	csv_file_callgraph=$TmpDataPath/CallGraph.csv
	target_csv_file_callgraph="${DataPath}/relationships.csv"
	echo -e "$title_row_callgraph\n$(cat $csv_file_callgraph)" > $target_csv_file_callgraph

	echo "已添加标题行到CSV文件中。"

	cmd="neo4j-admin database import full --nodes=$target_csv_file --relationships=$target_csv_file_callgraph --delimiter=TAB --overwrite-destination"
	echo $cmd
	eval $cmd

	# # 使用 docker exec 来复制文件
	# sudo docker exec neo4j_local cp -R /tmp/conf/neo4j.conf /var/lib/neo4j/conf
	# sudo docker exec neo4j_local cp /tmp/import/CallGraph.csv /var/lib/neo4j/import
	# sudo docker exec neo4j_local cp /tmp/import/Nodes.csv /var/lib/neo4j/import

    # # 如果Neo4j服务还未运行，则启动服务
    # sudo docker restart neo4j_local

	# if check_neo4j ; then
	# 	echo "Neo4j 已成功启动。"

	# 	sudo docker exec neo4j_local /tmp/import/init-db.sh

	# 	echo "Neo4j数据导入完成。"

	# else
	# 	echo "启动 Neo4j 超时。"
	# fi
}

# 检查 Neo4j 是否启动的函数
check_neo4j() {
    local elapsed=0
	
	# 容器名称或 ID
	local CONTAINER_NAME="neo4j"
	
	# Neo4j 认证信息，格式为 username/password
	local NEO4J_AUTH="neo4j/password"

	# 超时设置（秒）
	local TIMEOUT=60

    while [ $elapsed -lt $TIMEOUT ]; do
        # 使用 cypher-shell 尝试连接 Neo4j
        if sudo docker exec neo4j_local cypher-shell -u ${NEO4J_AUTH%/*} -p ${NEO4J_AUTH#*/} "RETURN 'Neo4j is running';" &> /dev/null; then
            return 0
        else
            echo "等待 Neo4j 启动..."
            sleep 5
            elapsed=$((elapsed + 5))
        fi
    done
    return 1
}

export -f import_neo4j_data