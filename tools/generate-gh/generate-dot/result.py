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
      (endNode:Node {name: '<java.lang.ProcessBuilder: java.lang.Process start()>'}),
      (requiredNode:Node {name: '<clojure.lang.RestFn: java.lang.Object applyTo(clojure.lang.ISeq)>'})
MATCH path1 = shortestPath((startNode)-[:CONNECTS_TO*]->(requiredNode))
MATCH path2 = shortestPath((requiredNode)-[:CONNECTS_TO*]->(endNode))
WHERE NONE(node IN nodes(path1) WHERE node.name IN ['<clojure.core$parse_opts_PLUS_specs: java.lang.Object invoke(java.lang.Object)>','<clojure.core$check_cyclic_dependency: java.lang.Object invokeStatic(java.lang.Object)>','<clojure.lang.PersistentArrayMap$Iter: java.lang.Object next()>','<clojure.core.proxy$clojure.lang.APersistentMap$ff19274a: java.lang.Object get(java.lang.Object)>','<clojure.core.proxy$java.io.Writer$ff19274a: boolean equals(java.lang.Object)>','<clojure.core.proxy$clojure.lang.APersistentMap$ff19274a: boolean containsKey(java.lang.Object)>','<clojure.test$run_all_tests: java.lang.Object invoke(java.lang.Object)>','<clojure.java.shell$parse_args: java.lang.Object invoke(java.lang.Object)>','<clojure.core.proxy$clojure.lang.APersistentMap$ff19274a: java.lang.Object invoke(java.lang.Object)>','<clojure.core$fits_table_QMARK_: java.lang.Object invoke(java.lang.Object)>','<clojure.data$vectorize: java.lang.Object invoke(java.lang.Object)>','<clojure.lang.FnLoaderThunk: java.lang.Object doInvoke(java.lang.Object)>','<clojure.lang.APersistentSet: int hashCode()>','<clojure.lang.ASeq: int hashCode()>','<clojure.core.proxy$clojure.lang.APersistentMap$ff19274a: int hashCode()>', '<clojure.core.proxy$clojure.lang.APersistentMap$ff19274a: boolean equals(java.lang.Object)>',
'<java.util.Hashtable: void reconstitutionPut(java.util.Hashtable$Entry[],java.lang.Object,java.lang.Object)>','<clojure.inspector.proxy$javax.swing.table.AbstractTableModel$ff19274a: boolean equals(java.lang.Object)>','<java.util.PriorityQueue: void readObject(java.io.ObjectInputStream)>' ,'<clojure.inspector.proxy$javax.swing.table.AbstractTableModel$ff19274a: int hashCode()>'])  AND
      NONE(node IN nodes(path2) WHERE node.name = '<org.apache.commons.collections.MultiHashMap: java.lang.Object put(java.lang.Object,java.lang.Object)>')
RETURN path1, path2
    """
    return tx.run(query).data()  # 使用 .data() 方法获取所有结果

# def create_dot_graph(data):
#     dot = Digraph(comment='Paths Graph')
#     added_edges = set()  # 用于跟踪已添加的边

#     for record in data:
#         elements = record["path"]
#         previous_node_id = None

#         for element in elements:
#             if isinstance(element, dict):  # 这是一个节点
#                 node_id = element["name"].replace('<', '').replace('>', '').replace(':', '_').replace(' ', '_')
#                 dot.node(node_id, element["name"].replace('<', '').replace('>', '').replace(':', '_').replace(' ', '_'))
                
#                 if previous_node_id is not None:
#                     edge = (previous_node_id, node_id)
#                     if edge not in added_edges:  # 检查这条边是否已经添加
#                         dot.edge(previous_node_id, node_id)
#                         added_edges.add(edge)  # 记录这条边以避免重复添加

#                 previous_node_id = node_id

#     return dot


def create_dot_graph(data):
    dot = Digraph(comment='Paths Graph')
    added_edges = set()  # 用于跟踪已添加的边

    for record in data:
        path1 = record["path1"]
        path2 = record["path2"]
        previous_node_id = None

        for element in path1 + path2:
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
output_path = os.path.join(current_dir, '../output', 'output_graph.dot')

# 保存和显示图像
dot.render(output_path)

# 关闭数据库连接
driver.close()
