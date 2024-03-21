#!/bin/bash
# author: fe1w0

# 获取终端宽度
terminal_width=$(tput cols)

# 生成与终端宽度匹配的分隔线
separator=$(printf '=%.0s' $(seq 1 $terminal_width))

module_separator=$(printf -- '-%.0s' $(seq 1 $terminal_width))


# 函数：在终端中心打印文本
print_centered() {
    local text="$1"  # 要居中打印的文本

    # 获取终端宽度
    local terminal_width=$(tput cols)

    # 计算文本的长度
    local text_length=${#text}

    # 计算需要多少前导字符才能使文本居中
    local padding_width=$(( (terminal_width - text_length) / 2 ))

    # 如果计算的填充宽度小于0，设置为0
    if [ $padding_width -lt 0 ]; then
        padding_width=0
    fi

    # 生成前导字符
    local padding=$(printf -- '-%.0s' $(seq 1 $padding_width))

    # 打印居中的文本
    echo "${padding}${text}${padding}"

    # 如果自定义文本加上两边的填充长度超过终端宽度，则尾部填充会被裁剪
}

export -f print_centered