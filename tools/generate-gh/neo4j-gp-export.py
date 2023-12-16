from py2neo import Graph
from graphviz import Digraph

def fetch_data_from_neo4j(uri, user, password, query):
    graph = Graph(uri, auth=(user, password))
    return graph.run(query)

def create_dot_graph(results):
    dot = Digraph(comment='Neo4j Graph')
    nodes = set()
    edges = set()

    for record in results:
        for path in record:
            for relationship in path.relationships:
                start_node = relationship.start_node
                end_node = relationship.end_node
                nodes.add((start_node.identity, start_node['name']))
                nodes.add((end_node.identity, end_node['name']))
                edges.add((start_node.identity, end_node.identity))

    for node in nodes:
        dot.node(str(node[0]), label=node[1])

    for edge in edges:
        dot.edge(str(edge[0]), str(edge[1]))

    return dot

# Replace these with your Neo4j credentials
uri = "bolt://localhost:7687"
user = "neo4j"
password = "xzas@157"

# Your specific Neo4j query
query = """
MATCH (startNode:Node {name: '<Start Method>'}), (endNode:Node {name: '<java.lang.reflect.Method: java.lang.Object invoke(java.lang.Object,java.lang.Object[])>'}), path = allShortestPaths((startNode)-[:CONNECTS_TO*]->(endNode)) 
WHERE NONE(node IN nodes(path) WHERE node.name = '<org.apache.commons.collections.MultiHashMap: java.lang.Object put(java.lang.Object,java.lang.Object)>')
AND NONE(node IN nodes(path) WHERE node.name = '<java.util.HashMap: java.lang.Object putVal(int,java.lang.Object,java.lang.Object,boolean,boolean)>')
RETURN path
"""

# Fetch data from Neo4j
results = fetch_data_from_neo4j(uri, user, password, query)

# Create DOT graph
dot_graph = create_dot_graph(results)

# Save or render the graph
dot_graph.render('output_graph', format='svg', view=True)  # This will save and open the graph as an SVG file
