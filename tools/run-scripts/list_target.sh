#!/bin/bash
# author: fe1w0

# 导入文件
source utils/config/extract_dependencies.sh

# 函数: 列出 input.xml

extract_dependencies /data/DataSet-Software/tools/run-scripts/input.xml

for i in "${!IDS[@]}"; do
    echo "Target: ${IDS[i]}" "INPUT: ${INPUTS[i]}"
done