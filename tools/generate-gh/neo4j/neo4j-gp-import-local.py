from neo4j import GraphDatabase

class Neo4jImporter:
    def __init__(self, uri, user, password):
        self.driver = GraphDatabase.driver(uri, auth=(user, password))

    def close(self):
        self.driver.close()

    def import_csv(self, file_path, query):
        with self.driver.session() as session:
            session.run(query, file_path=file_path)

if __name__ == "__main__":
    uri = "neo4j://localhost:7687"  # Update with your Neo4j database URI
    user = "neo4j"                 # Update with your Neo4j username
    password = "password"          # Update with your Neo4j password

    importer = Neo4jImporter(uri, user, password)
    
    company_query = """
	LOAD CSV WITH HEADERS FROM 'file:///var/lib/neo4j/import/Nodes.csv' AS row FIELDTERMINATOR '\t'
	CREATE (a:Node {name: row.node})
 	"""
    importer.import_csv("Company.csv", company_query)
    
    company_query = """
    USING PERIODIC COMMIT 1000
    LOAD CSV WITH HEADERS FROM 'file:///var/lib/neo4j/import/CallGraph.csv' AS row FIELDTERMINATOR '\t'
	MATCH (a:Node {name: row.from})
	MATCH (b:Node {name: row.to})
	CREATE (a)-[:CONNECTS_TO]->(b)
    """
    importer.import_csv("Company.csv", company_query)

    importer.close()

print("[+] Finish.")