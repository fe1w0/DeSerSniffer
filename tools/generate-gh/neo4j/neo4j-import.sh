#!/bin/bash
# author: fe1w0

# 函数: 初始化
init_database() {
	# 使用局部变量存储参数
    local TmpDataPath=$1
    local DataPath=$2
	
	# 修改权限
	local CONFIG_FILE=$DataPath/../conf/neo4j.conf
	sudo chown -R $USER $DataPath/../
	sudo chmod -R u+rwx $DataPath/../

	# 修改 Neo4j 的 配置文件
	sudo tee "$CONFIG_FILE" > /dev/null <<EOF
dbms.tx_log.rotation.retention_policy=100M size
dbms.ssl.policy.bolt.enabled=false
dbms.memory.pagecache.size=5120M
dbms.connector.bolt.listen_address=0.0.0.0:7687
dbms.connector.http.listen_address=0.0.0.0:7474
dbms.directories.import=import
dbms.directories.logs=/logs
dbms.security.auth_enabled=false
EOF
}

# 函数: 导入数据到neo4j数据库
import_neo4j_data() {
    # 使用局部变量存储参数
    local TmpDataPath=$1
    local DataPath=$2

	#初始化配置文件和文件夹权限
	init_database $TmpDataPath $DataPath

	# 将文件复制到Neo4j的导入目录
	cp $TmpDataPath/*.csv $DataPath/

	# 为Nodes.csv文件创建带标题的csv
	title_row="node"
	csv_file="${DataPath}/Nodes.csv"
	echo -e "$title_row\n$(cat $csv_file)" > $csv_file

	# 为CallGraph.csv文件创建带标题的csv
	title_row_callgraph="from\tto"
	csv_file_callgraph="${DataPath}/CallGraph.csv"
	echo -e "$title_row_callgraph\n$(cat $csv_file_callgraph)" > $csv_file_callgraph

	echo "已添加标题行到CSV文件中。"

    # 如果Neo4j服务还未运行，则启动服务
    sudo docker restart neo4j

	if check_neo4j ; then
		echo "Neo4j 已成功启动。"

		# 初始化数据库，删除所有节点和关系
		echo "正在初始化数据库..."
		cat <<EOF | cypher-shell -u neo4j -p password
MATCH (n)
DETACH DELETE n;
EOF

		# 执行Cypher查询来导入数据
		# 导入节点数据
		echo "正在导入节点数据..."
    	cat <<EOF | cypher-shell -u neo4j -p password
LOAD CSV WITH HEADERS FROM 'file:///Nodes.csv' AS row FIELDTERMINATOR '\t'
CREATE (a:Node {name: row.node});
EOF

		# 导入CallGraph数据
		echo "正在导入CallGraph数据..."
		cat <<EOF | cypher-shell -u neo4j -p password
USING PERIODIC COMMIT 3000
LOAD CSV WITH HEADERS FROM 'file:///CallGraph.csv' AS row FIELDTERMINATOR '\t'
MATCH (a:Node {name: row.from})
MATCH (b:Node {name: row.to})
CREATE (a)-[:CONNECTS_TO]->(b);
EOF
	
		echo "Neo4j数据导入完成。"

	else
		echo "启动 Neo4j 超时。"
	fi
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
        if cypher-shell -u ${NEO4J_AUTH%/*} -p ${NEO4J_AUTH#*/} "RETURN 'Neo4j is running';" &> /dev/null; then
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