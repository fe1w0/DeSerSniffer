import os
from neo4j import GraphDatabase
from graphviz import Digraph

# 连接到 Neo4j 数据库
uri = "bolt://localhost:7687"  # 或者您的 Neo4j 实例 URI
username = "neo4j"            # 替换为您的用户名
password = "password"         # 替换为您的密码
driver = GraphDatabase.driver(uri, auth=(username, password))

def fetch_data(tx):
    query = """
    MATCH (startNode:Node {name: '<Start Method>'}), 
        (endNode:Node {name: '<java.io.FileOutputStream: void write(byte[])>'}),
        path = allShortestPaths((startNode)-[:CONNECTS_TO*]->(endNode))
    WHERE NONE(node IN nodes(path) WHERE node.name =~ '.*APersistentMap\$ff19274a.*' OR node.name =~ '.*AbstractTableModel\$ff19274a.*')
    RETURN path
    """
    return tx.run(query).data()  # 使用 .data() 方法获取所有结果

def create_dot_graph(data):
    dot = Digraph(comment='Paths Graph')
    added_edges = set()  # 用于跟踪已添加的边

    for record in data:
        elements = record["path"]
        previous_node_id = None

        for element in elements:
            if isinstance(element, dict):  # 这是一个节点
                node_id = element["name"].replace('<', '').replace('>', '').replace(':', '_').replace(' ', '_')
                dot.node(node_id, element["name"].replace('<', '').replace('>', '').replace(':', '_').replace(' ', '_'))
                
                if previous_node_id is not None:
                    edge = (previous_node_id, node_id)
                    if edge not in added_edges:  # 检查这条边是否已经添加
                        dot.edge(previous_node_id, node_id)
                        added_edges.add(edge)  # 记录这条边以避免重复添加

                previous_node_id = node_id

    return dot

# 连接并执行查询
with driver.session() as session:
    data = session.execute_read(fetch_data)  # 使用 execute_read

# 创建 DOT 图
dot = create_dot_graph(data)

# 计算输出路径
current_dir = os.path.dirname(__file__)
output_path = os.path.join(current_dir, '../output', 'output_graph.gv')

# 保存和显示图像
dot.render(output_path)

# 关闭数据库连接
driver.close()
