import xml.etree.ElementTree as ET
import pandas as pd

def parse_xml_to_csv(file_name, output_csv_file):
    # Parse XML file
    tree = ET.parse(file_name)
    root = tree.getroot()

    # Extract dependencies
    dependencies = []
    for dependency in root.findall('.//dependency'):
        group_id = dependency.find('groupId').text
        artifact_id = dependency.find('artifactId').text
        version = dependency.find('version').text

        # Component Name
        component_name = f"{group_id}_{artifact_id}_{version}".replace('.', '_').replace('-', '_')

        # Component Version
        component_version = f"{group_id}:{artifact_id}:{version}"

        dependencies.append((component_name, component_version))

    # Create DataFrame
    df = pd.DataFrame(dependencies, columns=['Component Name', 'Component Version'])

    # Export to CSV
    df.to_csv(output_csv_file, index=False)

# Example usage:
file_name = "/home/zhangying/Project/SoftwareAnalysis/DataSet-Software/testjars/input.xml.backup"
output_csv_file = "/home/zhangying/Project/SoftwareAnalysis/DataSet-Software/testjars/input.csv"
parse_xml_to_csv(file_name, output_csv_file)