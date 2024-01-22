#!/bin/bash
# author: fe1w0

# 导入文件
local DIR="$(dirname "$BASH_SOURCE")"

source ${DIR}/neo4j/neo4j-import.sh

run() {
	# Step 1: 设置 DOOP_ID 和 DOOP_OUT
	local Neo4jImport=$1
	local DOOP_OUT=$2
	local DOOP_ID=$3

	cp ${DOOP_OUT}/init_${INIT_DOOP_ID}/database/Method.facts ${DOOP_OUT}/${DOOP_ID}/database/Method.facts

	# Step 2: 生成 需要导入 neo4j 的 调用图
	souffle ${DIR}/call_graph/CallGraph.dl -F${DOOP_OUT}/${DOOP_ID}/database/ -D${DIR}/output

	# Step 3: 复制和修改调用图文件，并导入图数据库
	import_neo4j_data ${DIR}/output $Neo4jImport

	rm -rf ${DOOP_ID}/${DOOP_ID}/database/Method.facts
}

Neo4jImport=/data/MangoData/neo4j/import
DOOP_OUT=/data/MangoData/out

# INIT_DOOP_ID=ai_h2o_h2o_core_3_44_0_3
# DOOP_ID=ai_h2o_h2o_core_3_44_0_3_2

# INIT_DOOP_ID=org_clojure_clojure_1_12_0_alpha5
# DOOP_ID=org_clojure_clojure_1_12_0_alpha5_1

# INIT_DOOP_ID=cn_hutool_hutool_all_5_8_23
# DOOP_ID=cn_hutool_hutool_all_5_8_23_3

INIT_DOOP_ID=org_dom4j_dom4j_2_1_4
DOOP_ID=org_dom4j_dom4j_2_1_4_2

INIT_DOOP_ID=org_apache_dubbo_dubbo_3_2_9
DOOP_ID=org_apache_dubbo_dubbo_3_2_9_4

INIT_DOOP_ID==io_acryl_datahub_client_0_12_0_2
DOOP_ID=io_acryl_datahub_client_0_12_0_2_1

INIT_DOOP_ID=com_alibaba_nacos_nacos_client_2_3_0
DOOP_ID=com_alibaba_nacos_nacos_client_2_3_0_1

run $Neo4jImport $DOOP_OUT $DOOP_ID