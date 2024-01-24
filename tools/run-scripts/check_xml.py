import xml.etree.ElementTree as ET
from collections import defaultdict

def find_duplicate_dependencies(xml_file):
    tree = ET.parse(xml_file)
    root = tree.getroot()

    # 使用字典来存储依赖项及其出现的次数
    dependencies = defaultdict(int)

    # 遍历所有dependency元素
    for dependency in root.findall('.//dependency'):
        groupId = dependency.find('groupId').text if dependency.find('groupId') is not None else ''
        artifactId = dependency.find('artifactId').text if dependency.find('artifactId') is not None else ''
        version = dependency.find('version').text if dependency.find('version') is not None else ''

        # 创建一个唯一标识符来代表每个依赖项
        identifier = (groupId, artifactId, version)
        dependencies[identifier] += 1

    # 打印出现次数大于1的依赖项
    for dep, count in dependencies.items():
        if count > 1:
            print(f"Duplicate dependency found: groupId={dep[0]}, artifactId={dep[1]}, version={dep[2]} (Count: {count})")

BASE_DIR = '/mnt/data-512g/liuxr-data/ENV/DeSerSniffer'
# 使用示例
find_duplicate_dependencies( BASE_DIR + '/testjars/total.xml')
