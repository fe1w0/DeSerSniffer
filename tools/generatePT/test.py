import csv
import copy

root_class=''
edges = []
objects = {}
class_db = {}
class_mock_number = {}
all_nodes = []

# 缓存
CACHE_OBJECT = {}

pt_format = {
    "label": "",
    "className": "",
    "fieldName": None,
    "fields": []
}

MAX_C = 1

# 指定CSV文件路径
csv_file_path = 'PropertyTree.csv'  # 将 'your_file.csv' 替换为实际的文件路径


# 读取CSV文件并创建初始数据结构
def read_csv_and_initialize(csv_file_path):
    with open(csv_file_path, newline='') as is_file:
        csv_reader = csv.reader(is_file, delimiter='\t')

        for row in csv_reader:
            edge_node = {
                "label": row[0],
                "className": row[1],
                "fieldType": row[2],
                "fieldName": row[3]
            }
            class_name = row[1]

            if row[0] == "ROOT":
                root_class = class_name

            if class_name not in class_db:
                class_db[class_name] = {}

            if class_name not in objects:
                objects[class_name] = {row[3]: [row[2]]}
            elif row[3] not in objects[class_name]:
                objects[class_name][row[3]] = [row[2]]
            elif row[2] not in objects[class_name][row[3]]:
                objects[class_name][row[3]].append(row[2])

            edges.append(edge_node)


# 检查是否field_type的选项只有一个
def check_field_type_is_single(field_object):
    for tmp_field in field_object:
        if len(field_object[tmp_field]) != 1:
            return False
    return True


# 获得所有潜在的PT_node
def get_all_pt_from_objects(objects):
    final_result = []
    for object_name, root_object in objects.items():
        if check_field_type_is_single(root_object):
            final_result.append({object_name: root_object})
        else:
            tmp_result = [{}]
            for field_name, field_types in root_object.items():
                new_result = []
                for tmp in tmp_result:
                    for field_type in field_types:
                        tmp_copy = copy.deepcopy(tmp)
                        tmp_copy.setdefault(object_name, {})[field_name] = field_type
                        new_result.append(tmp_copy)
                tmp_result = new_result
            final_result.extend(tmp_result)
    return final_result


# 刷新缓存
def refresh_cache(root_class, all_nodes):
    CACHE_OBJECT[root_class] = [node for node in all_nodes if root_class in node]


# 递归获取 PT
def recursive_get_PT(edges, parent_class, current_class, object_node, parent_field_name, class_mock_number):
    label = None
    for e in edges:
        if e["className"] == current_class and e["fieldType"] == object_node[parent_class][parent_field_name] and e[
            "fieldName"] == parent_field_name:
            label = e["label"]
            break

    res_pt_json = {
        "label": label,
        "className": current_class,
        "fieldName": parent_field_name,
        "fields": []
    }

    if current_class in class_db:
        if class_mock_number[current_class] < 0:
            return res_pt_json

        current_fields = object_node[current_class]
        for field_name, field_types in current_fields.items():
            for field_type in field_types:
                child_pt_json = recursive_get_PT(edges, current_class, field_type, object_node, field_name,
                                                 class_mock_number)
                if child_pt_json:
                    res_pt_json["fields"].append(child_pt_json)
                    class_mock_number[field_type] -= 1

    return res_pt_json


# 从缓存获取 PT
def get_PT_from_cache(root_class, object_node):
    cache_objects = CACHE_OBJECT[root_class]
    pt_results = []
    for cache_object in cache_objects:
        res_pt_json = recursive_get_PT(edges=edges, parent_class=root_class,
                                       current_class=root_class, object_node=object_node,
                                       parent_field_name=None, class_mock_number=copy.deepcopy(class_mock_number))
        if isinstance(res_pt_json, list):
            pt_results.extend(res_pt_json)
        else:
            pt_results.append(res_pt_json)
    return pt_results


# 主程序
read_csv_and_initialize(csv_file_path)
refresh_cache(root_class, all_nodes)

# 获取所有 PT
for object_name, root_object in objects.items():
    pt_results = get_PT_from_cache(root_class, {object_name: root_object})
    for pt_result in pt_results:
        print(pt_result)
