import csv
import copy
import json
import os
import shutil

edges = []

root_class = ""

objects = {}

class_db = []

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

MAX_C = 2

# 指定CSV文件路径
csv_file_path = 'PropertyTree.csv'  # 将 'your_file.csv' 替换为实际的文件路径


# 检查是否field_type的选项只有一个
def check_field_type_is_single(field_object):
    for tmp_field in field_object:
        if len(field_object[tmp_field]) != 1:
            return False
    return True


# 获得所有潜在的PT_node
def get_all_pt_from_objects(objects):
    final_result = []
    for object_name in objects:
        result = []
        root_object = objects[object_name]
        field_idx = 0
        if check_field_type_is_single(root_object):
            # 只执行一次
            for key, value in root_object.items():
                final_result.append({object_name: {key: value[0]}})
        else:
            for field_name in root_object:
                tmp_result = []
                for field_type in root_object[field_name]:
                    # 初始化
                    if field_idx == 0:
                        tmp_object = {}
                        tmp_object[object_name] = {}
                        tmp_object[object_name][field_name] = field_type
                        tmp_result.append(tmp_object)
                    # 添加
                    else:
                        for idx in range(len(result)):
                            # 注意避免直接引用
                            tmp = copy.deepcopy(result[idx])
                            tmp[object_name].update({field_name: field_type})
                            tmp_result.append(tmp)
                result = tmp_result
                field_idx += 1
        final_result.extend(result)
    return final_result


def open_csv_file(csv_file_path):
    global root_class
    global all_nodes
    global edges

    # 打开CSV文件
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
                class_db.append(class_name)

            edges.append(edge_node)

        for tmp_node in edges:
            class_name = tmp_node["className"]
            field_name = tmp_node["fieldName"]
            field_type = tmp_node["fieldType"]

            if class_name not in objects:
                objects[class_name] = {field_name: [field_type]}
            elif field_name not in objects[class_name]:
                objects[class_name][field_name] = [field_type]
            elif field_type not in objects[class_name][field_name]:
                objects[class_name][field_name].append(field_type)

        # 必须 自上而下 进行选择

        all_nodes = get_all_pt_from_objects(objects)


# 检查当前node 是 root_node
def check_root_node(pts, root_class):
    for key, value in pts.items():
        if key == root_class:
            return True
    return False


# 从 edges 中获取 label 信息 
def get_label(edges, class_name, field_name, field_type):
    for e in edges:
        if e["className"] == class_name and e["fieldType"] == field_type and e["fieldName"] == field_name:
            return e["label"]


def refresh_cache(root_class, all_nodes):
    result = []
    for node in all_nodes:
        for key, value in node.items():
            if key == root_class:
                result.append(node)
    if result != []:
        CACHE_OBJECT[root_class] = result


def refresh_all():
    for class_name in class_db:
        refresh_cache(class_name, all_nodes)
        # 刷新次数: MAX_C
        class_mock_number[class_name] = MAX_C


# 递归获取 PT
def recursive_get_PT(edges, parent_class, current_class, object_node, parent_field_name, class_mock_number):
    label = get_label(edges, parent_class, parent_field_name, current_class)
    res_pt_json = {
        "label": "",
        "className": "",
        "fieldName": None,
        "fields": []
    }
    res_pt_json["className"] = current_class
    res_pt_json["fieldName"] = parent_field_name
    res_pt_json["label"] = label

    diverse_children_pt_json = []

    if current_class in class_db:

        if class_mock_number[current_class] <= 0:
            return res_pt_json

        current_fields = object_node[current_class]
        for field_name, field_type in current_fields.items():
            if field_type in class_db:
                class_mock_number[field_type] -= 1

                tmp_nodes = CACHE_OBJECT[field_type]
                if len(tmp_nodes) == 1:

                    child_pt_json = recursive_get_PT(edges, current_class, field_type, tmp_nodes[0], field_name,
                                                     copy.deepcopy(class_mock_number))
                    res_pt_json["fields"].append(child_pt_json)
                else:
                    for tmp_node in tmp_nodes:
                        child_pt_json = recursive_get_PT(edges, current_class, field_type, tmp_node, field_name,
                                                         copy.deepcopy(class_mock_number))
                        if type(child_pt_json) == list:
                            diverse_children_pt_json.extend(child_pt_json)
                        else:
                            diverse_children_pt_json.append(child_pt_json)
            else:
                child_pt_json = recursive_get_PT(edges, current_class, field_type, {}, field_name,
                                                 copy.deepcopy(class_mock_number))
                res_pt_json["fields"].append(child_pt_json)

                # 处理 diverse_children_pt_json
        if len(diverse_children_pt_json) != 0:
            final_res_pt_json = []
            for child_pt_json in diverse_children_pt_json:
                tmp_json = copy.deepcopy(res_pt_json)
                tmp_json["fields"].append(child_pt_json)
                if tmp_json not in final_res_pt_json:
                    final_res_pt_json.append(tmp_json)
            return final_res_pt_json
    return res_pt_json


def get_all_PT_json(edges, root_class):
    global CACHE_OBJECT
    tmp_o = CACHE_OBJECT[root_class]

    res = []

    for object_node in tmp_o:
        print("----------------------------------------------------------------------------------------------")
        print("object_node:", object_node)
        tmp_pt_json = recursive_get_PT(edges=edges, parent_class=root_class,
                                       current_class=root_class,
                                       object_node=object_node,
                                       parent_field_name=None,
                                       class_mock_number=copy.deepcopy(class_mock_number))
        print("tmp_pt_json:", tmp_pt_json)
        if type(tmp_pt_json) == list:
            res.extend(tmp_pt_json)
        elif type(tmp_pt_json) == dict:
            res.append(tmp_pt_json)
    return res


def write_dict_to_json_file(data_dict, file_path):
    """
    将字典写入JSON文件

    参数:
    - data_dict: 要写入文件的字典数据
    - file_path: JSON文件的路径

    返回:
    - 无
    """
    print("[+] Write to: " + file_path)
    with open(file_path, 'w', encoding='utf-8') as json_file:
        json.dump(data_dict, json_file, ensure_ascii=False, indent=4)


def create_folder_and_clear_contents(folder_path):
    """
    创建文件夹（如果不存在）并清空其内容

    参数:
    - folder_path: 要创建的文件夹路径

    返回:
    - 无
    """
    # 如果文件夹不存在，则创建它
    if not os.path.exists(folder_path):
        os.makedirs(folder_path)

    # 清空文件夹中的内容
    for filename in os.listdir(folder_path):
        file_path = os.path.join(folder_path, filename)
        try:
            if os.path.isfile(file_path):
                os.unlink(file_path)
            elif os.path.isdir(file_path):
                shutil.rmtree(file_path)
        except Exception as e:
            print(f"无法删除 {file_path}: {e}")


open_csv_file(csv_file_path)

refresh_all()

res_pt_json = get_all_PT_json(edges, root_class)

# print("CACHE_OBJECT: ", CACHE_OBJECT)

print("----------------------------------------------------------------------------------------------")

output_folder = "./Tree/"

create_folder_and_clear_contents(output_folder)

file_idx = 0
for pt_dict in res_pt_json:
    file_path = output_folder + str(file_idx) + ".json"
    write_dict_to_json_file(pt_dict, file_path)
    file_idx += 1
