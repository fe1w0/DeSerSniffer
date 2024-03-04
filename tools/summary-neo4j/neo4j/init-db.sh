#!/bin/bash
# author: fe1w0

echo "正在初始化数据库..."
cat <<EOF | cypher-shell -u neo4j -p password
MATCH (n)
DETACH DELETE n;
EOF

echo "正在导入节点数据..."
cat <<EOF | cypher-shell -u neo4j -p password
CALL {
  LOAD CSV WITH HEADERS FROM 'file:///Nodes.csv' AS row FIELDTERMINATOR '\t'
  CREATE (a:Node {name: row.node})
}
IN TRANSACTIONS OF 3000 ROWS
EOF

echo "正在导入CallGraph数据..."
cat <<EOF | cypher-shell -u neo4j -p password
CALL {
  LOAD CSV WITH HEADERS FROM 'file:///CallGraph.csv' AS row FIELDTERMINATOR '\t'
  MATCH (a:Node {name: row.from})
  MATCH (b:Node {name: row.to})
  CREATE (a)-[:CONNECTS_TO]->(b)
}
IN TRANSACTIONS OF 3000 ROWS
EOF
