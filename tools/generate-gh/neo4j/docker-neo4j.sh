#!/bin/bash
# author: fe1w0

# 导入文件
dir="$(dirname "$BASH_SOURCE")"

# 加载 doop 配置模块, doop_config 提供 DOOP_OUT
source "${dir}/../../run-scripts/utils/config/doop_config.sh"

# 导入配置
doop_config

mkdir -p $DOOP_RESULT/neo4j
mkdir -p $DOOP_RESULT/neo4j/data
mkdir -p $DOOP_RESULT/neo4j/logs
mkdir -p $DOOP_RESULT/neo4j/conf
mkdir -p $DOOP_RESULT/neo4j/import

sudo docker run -d --name neo4j_local -p 27474:7474 -p 27687:7687 -v $DOOP_RESULT/neo4j/data/:/data -v $DOOP_RESULT/neo4j/logs:/logs -v $DOOP_RESULT/neo4j/conf:/var/lib/neo4j/conf -v $DOOP_RESULT/neo4j/import:/var/lib/neo4j/import --env NEO4J_AUTH=neo4j/password neo4j