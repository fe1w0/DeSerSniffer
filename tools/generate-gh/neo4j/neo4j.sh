#!/bin/bash

# Setup Project ID
DOOP_ID=XXX
DOOP_OUT_PATH=XXXX

# Start Neo4j service if it's not already running
sudo neo4j start

# Initialize the database by deleting all nodes and relationships
# Replace 'password' with your actual Neo4j password
echo "Initializing the database..."

cat <<EOF | cypher-shell -u neo4j -p password
MATCH (n)
DETACH DELETE n;
EOF

# Copy files to the Neo4j import directory
cp $DOOP_OUT_PATH/$DOOP_ID/database/.csv /var/lib/neo4j/import/

# Create titled csv -  Nodes.csv
title_row="Column1\tColumn2\tColumn3"
csv_file="/var/lib/neo4j/import/.csv"
echo -e "$title_row\n$(cat $csv_file)" > $csv_file

# Create titled csv - CallGraph.csv

echo "Title row added to the CSV file."

# Run Cypher queries to import data
# Replace 'password' with your actual Neo4j password
# Import Nodes
echo "Importing Nodes..."
cat <<EOF | cypher-shell -u neo4j -p password
LOAD CSV WITH HEADERS FROM 'file:///var/lib/neo4j/import/Nodes.csv' AS row FIELDTERMINATOR '\t'
MERGE (a:Node {name: row.node});
EOF

# Import CallGraph
echo "Importing CallGraph..."
cat <<EOF | cypher-shell -u neo4j -p password
USING PERIODIC COMMIT 1000
LOAD CSV WITH HEADERS FROM 'file:///var/lib/neo4j/import/CallGraph.csv' AS row FIELDTERMINATOR '\t'
MATCH (a:Node {name: row.from})
MATCH (b:Node {name: row.to})
MERGE (a)-[:CONNECTS_TO]->(b);
EOF

echo "Neo4j data import complete."
