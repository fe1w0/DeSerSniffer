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
    DOOP_LOGS=$DOOP_HOME/logs
    echo "DOOP Logs: $DOOP_LOGS"
    echo "TMP Logs: /tmp/doop_*"
    echo

    # 用户确认
    read -p "Are you sure you want to clear all DOOP data? (y/N) " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        # 清理 OUT 
        rm -rf "$DOOP_OUT"

        # 清理 Cache
        rm -rf "$DOOP_CACHE"

        # 清理 DOOP 日志
        rm -rf $DOOP_LOGS/*

        # 清理 TMP 日志
        rm -rf /tmp/doop_*
    else
        echo "Clear operation cancelled."
    fi
}

# 调用 clear_result 函数以执行清理
clear_result
