#!/bin/bash
# author: fe1w0

# 函数: doop 设置
doop_config() {
    ## 设置DOOP参数
    DOOP_HOME=/mnt/data-512g/liuxr-data/ENV/doop-other/build/install/doop
    DOOP_RESULT=/mnt/data-512g/liuxr-data/Data
    DOOP_CACHE=$DOOP_RESULT/cache
    DOOP_OUT=$DOOP_RESULT/summary-data/
    BASE_DIR=/mnt/data-512g/liuxr-data/ENV/DeSerSniffer-summary-algorithm
    FuzzChainsPath=/mnt/data-512g/liuxr-data/ENV/FuzzChains
    JAVA_HOME=/home/liuxr/opt/jdk-17.0.10
    JAVA_VERSION=java_8
    JOBS=54

    ## 设置 DOOP_PLATFORMS_LIB
    export DOOP_PLATFORMS_LIB=/mnt/data-512g/liuxr-data/ENV/doop-benchmarks

    ## 设置 DOOP_OUT 参数
    # 检查环境变量$DOOP_OUT是否设置
    if [ -n "$DOOP_OUT" ]; then
    # 如果设置了，将$DOOP_OUT的值赋给$DOOP_OUT
    export DOOP_OUT="$DOOP_OUT"
    else
    # 如果未设置，将${DOOP_HOME}/out的值赋给$DOOP_OUT
    export DOOP_OUT="${DOOP_HOME}/out"
    fi

    ## 设置 DOOP_CACHE 参数
    # 检查环境变量 $DOOP_CACHE 是否设置
    if [ -n "$DOOP_CACHE" ]; then
    # 如果设置了，将$DOOP_CACHE的值赋给 $DOOP_CACHE
    export DOOP_CACHE="$DOOP_CACHE"
    else
    # 如果未设置，将${DOOP_HOME}/cache 的值赋给$DOOP_OUT
    export DOOP_CACHE="${DOOP_HOME}/cache"
    fi
}

export -f doop_config