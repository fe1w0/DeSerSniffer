from graphviz import Digraph
import csv

method_calls = []

filename = 'scc_call_graph.csv'

with open(filename, 'r') as file:
    reader = csv.reader(file, delimiter='\t')  # 使用制表符作为分隔符
    for row in reader:
        method_calls.append(row)  # 将每行添加到 method_calls 列表中

def sanitize_method_name(method_name):
    # 替换特殊字符以避免解析问题
    return method_name.replace('<', '').replace('>', '').replace(':', '_').replace(' ', '_')

def create_dot_file(method_calls):
    dot = Digraph(comment='Method Calls Graph')

    # 为每个唯一的方法添加节点
    methods = set()
    for call in method_calls:
        methods.add(call[0])
        methods.add(call[1])
    
    for method in methods:
        sanitized_method = sanitize_method_name(method)
        dot.node(sanitized_method, method)

    # 添加边
    for call in method_calls:
        sanitized_src = sanitize_method_name(call[0])
        sanitized_dst = sanitize_method_name(call[1])
        dot.edge(sanitized_src, sanitized_dst)

    # 保存为DOT文件
    dot.render('method_calls_graph', format='dot')

create_dot_file(method_calls)