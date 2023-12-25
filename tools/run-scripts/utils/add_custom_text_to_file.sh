#!/bin/bash
# author: fe1w0

# 函数：生成analysis.dl文件

add_custom_text_to_file() {
    local source_file=$1
    local destination_file=$2
    local MaxNumberMaybeTaintedField=$3

    # 检查文件是否存在
    if [ ! -f "$source_file" ]; then
        echo "文件不存在: $source_file"
        return 1
    fi

    # 要添加的文本
    local text_to_add="// -----------------------------------------------------------------------------\n"
    text_to_add+="// Start Custom rules\n"
    text_to_add+="// -----------------------------------------------------------------------------\n\n"
    text_to_add+="#define MAX_Number_MaybeTaintedField ${MaxNumberMaybeTaintedField}\n"

    # 将文本添加到目标文件
    echo -e "$text_to_add" > "$destination_file"  # 创建新文件或覆盖现有文件
    cat "$source_file" >> "$destination_file"  # 追加源文件的内容到目标文件
}
