#!/bin/bash

# 读取输入的标签
label="<datahub.shaded.com.google.common.collect.LinkedListMultimap: void readObject(java.io.ObjectInputStream)>::<datahub.shaded.org.springframework.util.MimeType: void readObject(java.io.ObjectInputStream)> -> <java.lang.reflect.Method: java.lang.Object invoke(java.lang.Object,java.lang.Object[])>"

# 定义输出文件名
output_file="filtered_data.csv"

# 检查 PotentialVulnGraph.csv 文件是否存在
if [ ! -f "/home/zhangying/Project/SoftwareAnalysis/Result/out/io_acryl_datahub_client_0_12_0_2_9/database/PotentialVulnGraph.csv" ]; then
    echo "文件不存在!"
    exit 1
fi

# 使用 awk 处理 CSV 文件
awk -F '\t' -v label="$label" '
BEGIN {OFS = "	"}
$1 == label {print $2, $3}
' "/home/zhangying/Project/SoftwareAnalysis/Result/out/io_acryl_datahub_client_0_12_0_2_9/database/PotentialVulnGraph.csv" > "$output_file"

echo "输出已保存到 $output_file"
