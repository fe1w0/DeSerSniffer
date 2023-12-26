#!/bin/bash
# author: fe1w0

# 定义全局数组
declare -a IDS
declare -a INPUTS

# 函数：提取依赖信息
extract_dependencies() {
    local file_path="$1"

    # 检查文件是否存在
    if [ ! -f "$file_path" ]; then
        echo "文件不存在: $file_path"
        return 1
    fi

    # 清空数组
    IDS=()
    INPUTS=()

    # 读取文件并处理每个依赖
    while read -r line; do
        # 检查并提取 groupId, artifactId, version
        if [[ $line =~ \<groupId\>(.*)\</groupId\> ]]; then
            groupId=${BASH_REMATCH[1]}
        elif [[ $line =~ \<artifactId\>(.*)\</artifactId\> ]]; then
            artifactId=${BASH_REMATCH[1]}
        elif [[ $line =~ \<version\>(.*)\</version\> ]]; then
            version=${BASH_REMATCH[1]}
            
            # 生成 ID 和 INPUT
            ID=$(echo "${groupId}_${artifactId}_${version}" | tr '.:-' '_')
            INPUT="${groupId}:${artifactId}:${version}"

            # 将信息添加到数组
            IDS+=("$ID")
            INPUTS+=("$INPUT")

            # 重置变量以处理下一个依赖项
            unset groupId artifactId version
        fi
    done < <(grep -E "(groupId|artifactId|version)" "$file_path")
}

export -f extract_dependencies

# # 使用函数
# extract_dependencies /data/DataSet-Software/tools/run-scripts/input.xml

# # 输出结果
# echo "IDS: ${IDS[@]}"
# echo "INPUTS: ${INPUTS[@]}"
