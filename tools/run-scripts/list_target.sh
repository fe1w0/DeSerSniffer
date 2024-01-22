#!/bin/bash
# author: fe1w0

# 导入文件
dir="$(dirname "$BASH_SOURCE")"

source $dir/utils/config/doop_config.sh
source $dir/utils/config/extract_dependencies.sh

# 导入配置
doop_config

# 函数: 列出 input.xml
extract_dependencies $BASE_DIR/testjars/input.xml

for i in "${!IDS[@]}"; do
    echo "Target: ${IDS[i]}" "INPUT: ${INPUTS[i]}"
done