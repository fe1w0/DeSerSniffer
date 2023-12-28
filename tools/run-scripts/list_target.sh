#!/bin/bash
# author: fe1w0

# 导入文件
source utils/config/extract_dependencies.sh

# 函数: 列出 input.xml

extract_dependencies /home/zhangying/Project/SoftwareAnalysis/DataSet-Software/testjars/input.xml

for i in "${!IDS[@]}"; do
    echo "Target: ${IDS[i]}" "INPUT: ${INPUTS[i]}"
done