#!/bin/sh
# author: fe1w0

sudo docker run -d --name neo4j -p 7474:7474 -p 7687:7687 -v /data/MangoData/neo4j/data/:/data -v /data/MangoData/neo4j/logs:/logs -v /data/MangoData/neo4j/conf:/var/lib/neo4j/conf -v /data/MangoData/neo4j/import:/var/lib/neo4j/import --env NEO4J_AUTH=neo4j/password neo4j