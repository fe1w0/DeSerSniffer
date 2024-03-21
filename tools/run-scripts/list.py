import xml.etree.ElementTree as ET
import pandas as pd
import os

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

# 计算输出路径
current_dir = os.path.dirname(__file__)

file_name = os.path.join(current_dir, '../../testjars', 'finish.xml')
output_csv_file = os.path.join(current_dir, '../../output', 'finish.csv')

parse_xml_to_csv(file_name, output_csv_file)