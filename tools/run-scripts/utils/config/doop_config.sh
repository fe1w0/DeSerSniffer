#!/bin/bash
# author: fe1w0

# 函数: doop 设置
doop_config() {
    ## 设置DOOP参数
    DOOP_HOME=/doop/build/install/doop
    BASE_DIR=/data/DataSet-Software/
    FuzzChainsPath=/data/FuzzChains/
    JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
    JAVA_VERSION=java_8
    JOBS=33

    ## 设置 DOOP_OUT 参数
    # 检查环境变量$DOOP_OUT是否设置
    if [ -n "$DOOP_OUT" ]; then
    # 如果设置了，将$DOOP_OUT的值赋给$DOOP_OUT
    export DOOP_OUT="$DOOP_OUT"
    else
    # 如果未设置，将${DOOP_HOME}/out的值赋给$DOOP_OUT
    export DOOP_OUT="${DOOP_HOME}/out"
    fi

    ## 允许 补充的污点源的最大数量
    MaxNumberMaybeTaintedField=60000

    ## 设置 DOOP_PLATFORMS_LIB
    export DOOP_PLATFORMS_LIB=/doop-benchmarks/

    ## 设置子项目对象限制数字
    SplitLineNumber=6
}

export -f doop_config