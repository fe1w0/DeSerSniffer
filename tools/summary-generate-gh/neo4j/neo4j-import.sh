#!/bin/bash
# author: fe1w0

# 导入文件
import_dir="$(dirname "$BASH_SOURCE")"


# 函数: 导入数据到neo4j数据库
import_neo4j_data() {
    # 使用局部变量存储参数
    local TmpDataPath=$1

	# 使用 sed 命令直接在文件开头添加标题行
	title_row="name:ID(Node)\t:LABEL"
	csv_file="$TmpDataPath/Nodes.csv"
	sed -i "1s/^/$title_row\n/" $csv_file

	# 使用 sed 命令直接在文件开头添加标题行
	title_row_callgraph=":START_ID(Node)\t:END_ID(Node)\tlabel\t:TYPE"
	csv_file_callgraph="$TmpDataPath/CallGraph.csv"
	sed -i "1s/^/$title_row_callgraph\n/" $csv_file_callgraph

	cmd="neo4j stop"
	echo $cmd
	eval $cmd

	cmd="neo4j-admin database import full --nodes=$csv_file --relationships=$csv_file_callgraph --delimiter=TAB --overwrite-destination"
	echo $cmd
	eval $cmd

	echo "Neo4j数据导入完成。"

	cmd="neo4j start"
	echo $cmd
	eval $cmd
}

export -f import_neo4j_data