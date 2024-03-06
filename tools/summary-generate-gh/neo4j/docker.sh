# #!/bin/bash
# # author: fe1w0

# # 导入文件
# dir="$(dirname "$BASH_SOURCE")"

# # 加载 doop 配置模块, doop_config 提供 DOOP_OUT
# source "${dir}/../../run-scripts/utils/config/doop_config.sh"

# # 导入配置
# doop_config

# # mkdir -p $DOOP_RESULT/neo4j
# # mkdir -p $DOOP_RESULT/neo4j/data
# # mkdir -p $DOOP_RESULT/neo4j/logs
# # mkdir -p $DOOP_RESULT/neo4j/conf
# # mkdir -p $DOOP_RESULT/neo4j/import
# # mkdir -p $DOOP_RESULT/neo4j-data/

# sudo docker run -d --name neo4j_local -p 7474:7474 -p 7687:7687 -v $DOOP_RESULT/neo4j/:/tmp --env NEO4J_AUTH=neo4j/password neo4j


# # sudo docker run -d --name neo4j_local -p 7474:7474 -p 7687:7687 -v $DOOP_RESULT/neo4j/data/:/data -v $DOOP_RESULT/neo4j/logs:/logs -v $DOOP_RESULT/neo4j/conf:/var/lib/neo4j/conf -v $DOOP_RESULT/neo4j/import:/var/lib/neo4j/import -v $DOOP_RESULT/neo4j-data/:/tmp --env NEO4J_AUTH=neo4j/password neo4j

# # sudo docker run --interactive --rm \
# #     --name neo4j_local \
# #     --publish=7474:7474 --publish=7687:7687 \
# #     --volume="$DOOP_RESULT/neo4j/data/var/lib/neo4j/data" \
# #     --volume="$DOOP_RESULT/neo4j/import:/var/lib/neo4j/import" \
# #     --volume="$DOOP_RESULT/neo4j/conf:/var/lib/neo4j/conf" \
# #     --volume="$DOOP_RESULT/neo4j/logs:/var/lib/neo4j/logs" \
# #     --volume="$DOOP_RESULT/neo4j-data/:/tmp" \
# #     --env NEO4J_AUTH=neo4j/password neo4j \
# #     /bin/bash -c 'neo4j-admin import --nodes=/tmp/import/nodes.csv --relationships=/tmp/import/relationships.csv --delimiter="\t" --high-io=true --processors=20 --database=neo4j --ignore-empty-strings=true --ignore-extra-columns=true --skip-bad-relationships=true --skip-duplicate-nodes=true'