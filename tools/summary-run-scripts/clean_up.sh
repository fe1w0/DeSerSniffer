#!/bin/bash
# author: fe1w0

# 导入文件
dir="$(dirname "$BASH_SOURCE")"

# 加载 doop 配置模块, doop_config 提供 DOOP_OUT
source "${dir}/utils/config/doop_config.sh"

# 函数: 清理 🧹
clear_result() {
    # 显示即将删除的目录
    echo "The following directories will be cleared:"
    echo "OUT Directory: $DOOP_OUT"
    echo "Cache Directory: $DOOP_CACHE"
    DOOP_LOGS=$DOOP_HOME/build/logs/
    echo "DOOP Logs: $DOOP_LOGS"
    echo "TMP Logs: /tmp/doop_*"

    # 用户确认
    if [[ $1 == "-y" ]]; then
        REPLY="y"
    elif [[ $1 == "-l" ]]; then
        REPLY="l"
    else
        read -p "Are you sure you want to clear all DOOP data? (y/N), or just delete all log files (l)" -n 1 -r
        echo    # (optional) move to a new line
    fi

    if [[ $REPLY =~ ^[Yy]$ ]]
    then
		# 清理 DOOP 日志
        rm -rf $DOOP_LOGS/*

        # 清理 TMP 日志
        rm -rf /tmp/doop_*

        ## 清理 OUT， 但排除 子项目的分析日志
        rm -rf "$DOOP_OUT" 

		# find "$DOOP_OUT/" -type d -not -path "$DOOP_OUT/log" -exec rm -rf {} +

        # # 清理 Cache
        rm -rf "$DOOP_CACHE"

		mkdir -p $DOOP_OUT
		mkdir -p $DOOP_CACHE
    elif [[ $REPLY =~ ^[lL]$ ]] ; then
        rm -rf $DOOP_LOGS/*
        rm -rf /tmp/doop_*
    else
        echo "Clear operation cancelled."
    fi
}

# 导入配置
doop_config

# 判断是否传入了 "-y" 参数
if [[ $# -eq 1 && ($1 == "-y" || $1 == "-l") ]]; then
    clear_result $1
else
    # 调用 clear_result 函数以执行清理
    clear_result
fi