#!/bin/bash
# author: fe1w0

# 导入文件
DIR="$(dirname "$BASH_SOURCE")"

source $DIR/neo4j/neo4j-import.sh

run() {
	# Step 1: 设置 DOOP_ID 和 DOOP_OUT
	local Neo4jImport=$1
	local DOOP_OUT=$2
	local DOOP_ID=$3

	# Step 2: 生成 需要导入 neo4j 的 调用图
	souffle $DIR/call_graph/CallGraph.dl -F${DOOP_OUT}/${DOOP_ID}/database/ -D${DIR}/output

	# Step 3: 复制和修改调用图文件，并导入图数据库
	import_neo4j_data $DIR/output $Neo4jImport
}

Neo4jImport=/data/MangoData/neo4j/import
DOOP_OUT=/data/MangoData/out
DOOP_ID=org_apache_dubbo_dubbo_3_2_9_4
run $Neo4jImport $DOOP_OUT $DOOP_ID