#!/bin/bash
# author: fe1w0

# 导入文件
DIR="$(dirname "$BASH_SOURCE")"

source "${DIR}/../run-scripts/utils/config/doop_config.sh"
source "${DIR}/neo4j/neo4j-import.sh"

run() {
	# Step 1: 设置 DOOP_ID 和 DOOP_OUT
	local Neo4jImport=$1
	local DOOP_OUT=$2
	local DOOP_ID=$3

	cp ${DOOP_OUT}/init_${INIT_DOOP_ID}/database/Method.facts ${DOOP_OUT}/${DOOP_ID}/database/Method.facts

	mkdir -p ${DIR}/output

	# Step 2: 生成 需要导入 neo4j 的 调用图
	souffle --no-warn ${DIR}/call_graph/CallGraph.dl -F${DOOP_OUT}/${DOOP_ID}/database/ -D${DIR}/output

	# Step 3: 复制和修改调用图文件，并导入图数据库
	mkdir -p $Neo4jImport
	import_neo4j_data ${DIR}/output $Neo4jImport

	# rm -rf ${DOOP_ID}/${DOOP_ID}/database/Method.facts
}

# 导入配置
doop_config

Neo4jImport=$DOOP_RESULT/neo4j-data/import
DOOP_OUT=$DOOP_OUT

###################################### Set Doop ID #####################################

INIT_DOOP_ID=org_clojure_clojure_1_12_0_alpha5
DOOP_ID=summary_org_clojure_clojure_1_12_0_alpha5

########################################### End #########################################

run $Neo4jImport $DOOP_OUT $DOOP_ID