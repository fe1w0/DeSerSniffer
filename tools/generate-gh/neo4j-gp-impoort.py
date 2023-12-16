from neo4j import GraphDatabase
import csv

class Neo4jConnection:
    def __init__(self, uri, user, pwd):
        self.__uri = uri
        self.__user = user
        self.__password = pwd
        self.__driver = None
        try:
            self.__driver = GraphDatabase.driver(self.__uri, auth=(self.__user, self.__password))
        except Exception as e:
            print("Failed to create the driver:", e)
        
    def close(self):
        if self.__driver is not None:
            self.__driver.close()
        
    def query(self, query, parameters=None, db=None):
        assert self.__driver is not None, "Driver not initialized!"
        session = None
        response = None
        try: 
            session = self.__driver.session(database=db) if db is not None else self.__driver.session() 
            response = list(session.run(query, parameters))
        except Exception as e:
            print("Query failed:", e)
        finally: 
            if session is not None:
                session.close()
        return response

def import_csv_to_neo4j(connection, file_path):
    with open(file_path, 'r', newline='', encoding='utf-8') as file:
        reader = csv.reader(file, delimiter='\t')  # 设置分隔符为制表符
        for row in reader:
            if len(row) < 3:  # Skipping rows that don't have sufficient data
                continue
            node = row[1]
            next_node = row[2]

            # Creating nodes and the relationship
            query = """
            MERGE (a:Node {name: $node})
            MERGE (b:Node {name: $next_node})
            MERGE (a)-[:CONNECTS_TO]->(b)
            """
            connection.query(query, parameters={'node': node, 'next_node': next_node})

# Replace these variables with your Neo4j credentials and file path
uri = "bolt://localhost:7687"
user = "neo4j"
password = "xzas@157"
csv_file_path = "PotentialVulnGraph.csv"

# Establishing connection and importing data
conn = Neo4jConnection(uri, user, password)
import_csv_to_neo4j(conn, csv_file_path)
conn.close()
