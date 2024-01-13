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

	cp ${DOOP_OUT}/init_${INIT_DOOP_ID}/database/Method.facts ${DOOP_OUT}/${DOOP_ID}/database/Method.facts

	# Step 2: 生成 需要导入 neo4j 的 调用图
	souffle $DIR/call_graph/CallGraph.dl -F${DOOP_OUT}/${DOOP_ID}/database/ -D${DIR}/output

	# Step 3: 复制和修改调用图文件，并导入图数据库
	import_neo4j_data $DIR/output $Neo4jImport

	rm -rf ${DOOP_ID}/${DOOP_ID}/database/Method.facts
}

Neo4jImport=/data/MangoData/neo4j/import
DOOP_OUT=/data/MangoData/out
INIT_DOOP_ID=org_apache_beam_beam_sdks_java_core_2_52_0
DOOP_ID=org_apache_beam_beam_sdks_java_core_2_52_0_3
run $Neo4jImport $DOOP_OUT $DOOP_ID