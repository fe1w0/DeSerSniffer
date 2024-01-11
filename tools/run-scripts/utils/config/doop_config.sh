#!/bin/bash
# author: fe1w0

# 函数: doop 设置
doop_config() {
    ## 设置DOOP参数
    DOOP_HOME=/home/zhangying/Project/SoftwareAnalysis/ENV/doop/build/install/doop
    DOOP_RESULT=/home/zhangying/Project/SoftwareAnalysis/Result
    DOOP_CACHE="/data/MangoData/cache"
    DOOP_OUT="/data/MangoData/out"
    BASE_DIR=/home/zhangying/Project/SoftwareAnalysis/DataSet-Software
    FuzzChainsPath=/home/zhangying/Project/SoftwareAnalysis/FuzzChains
    JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
    JAVA_VERSION=java_8
    JOBS=48

    ## 设置 DOOP_PLATFORMS_LIB
    export DOOP_PLATFORMS_LIB=/home/zhangying/Project/SoftwareAnalysis/ENV/doop-benchmarks

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

    ## 允许 补充的污点源的最大数量
    MaxNumberMaybeTaintedField=35000

    ## 设置子项目对象限制数字
    SplitLineNumber=5
}

export -f doop_config