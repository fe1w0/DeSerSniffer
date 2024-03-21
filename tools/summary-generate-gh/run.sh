#!/bin/bash
# author: fe1w0

# 导入文件
DIR="$(dirname "$BASH_SOURCE")"

source "${DIR}/../summary-run-scripts/utils/config/doop_config.sh"
source "${DIR}/neo4j/neo4j-import.sh"

run() {
	# Step 1: 设置 DOOP_ID 和 DOOP_OUT
	local Neo4jImport=$1
	local DOOP_OUT=$2
	local DOOP_ID=$3

	mkdir -p $Neo4jImport

	# Step 2: 生成 需要导入 neo4j 的 调用图
	cmd="souffle --no-warn ${DIR}/call_graph/CallGraph.dl -F${DOOP_OUT}/${DOOP_ID}/database/ -D$Neo4jImport -j $JOBS"
	echo $cmd
	eval $cmd

	# Step 3: 复制和修改调用图文件，并导入图数据库
	import_neo4j_data $Neo4jImport
}

# 导入配置
doop_config

Neo4jImport=$DOOP_RESULT/neo4j-data/import
DOOP_OUT=$DOOP_OUT

###################################### Set Doop ID #####################################

DOOP_ID=summary_com_alibaba_nacos_nacos_client_2_3_0
DOOP_ID=summary_org_clojure_clojure_1_12_0_alpha5


DOOP_ID=io_acryl_datahub_client_0_12_0_2

# 没有什么希望
DOOP_ID=org_apache_dubbo_dubbo_3_2_9

# 没有什么希望
DOOP_ID=cn_hutool_hutool_all_5_8_23

# 卡住了，net.sf.json.JSONObject 还是有点问题，无法直接使用
# ok，可以了，找到利用链了
DOOP_ID=org_zaproxy_zap_2_14_0

DOOP_ID=com_alibaba_fastjson_2_0_42

# 有可能
DOOP_ID=org_jeecgframework_boot_jeecg_boot_starter_rabbitmq_3_6_0

# 也不太行，无法使用 Jackson 的调用链
DOOP_ID=org_keycloak_keycloak_core_23_0_3

# 没有仔细看，但调用链很奇葩，需要用到 scala 和 spring
DOOP_ID=org_apache_beam_beam_runners_spark_2_45_0


DOOP_ID=ai_h2o_h2o_core_3_44_0_3

########################################### End #########################################

run $Neo4jImport $DOOP_OUT $DOOP_ID