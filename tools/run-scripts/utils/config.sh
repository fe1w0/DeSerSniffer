#!/bin/bash
# author: fe1w0

dir="$(dirname "$BASH_SOURCE")"

# 加载 overwrite 模块
source ${dir}/overwrite.sh

# 加载 生成analysis.dl文件 模块
source ${dir}/add_custom_text_to_file.sh

# 函数：初始化
config() {
    # 检测项目
    ID=com_alibaba_nacos_nacos_client_2_3_0
    INPUT=com.alibaba.nacos:nacos-client:2.3.0

    ## 设置DOOP参数
    DOOP_HOME=/doop/build/install/doop
    BASE_DIR=/data/DataSet-Software/
    FuzzChainsPath=/data/FuzzChains/
    JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
    JAVA_VERSION=java_8
    JOBS=33

    ## 允许 补充的污点源的最大数量
    MaxNumberMaybeTaintedField=50000
    ### 生成 最终analysis.dl 文件
    add_custom_text_to_file ${BASE_DIR}/tools/custom-rules/simple-analysis.dl ${BASE_DIR}/tools/custom-rules/analysis.dl $MaxNumberMaybeTaintedField
    echo "\t[+] Finish: Generate analysis.dl"

    ## overwrite doop
    overwrite $DOOP_HOME
    echo "\t[+] Finish: OverWrite"

    export DOOP_PLATFORMS_LIB=/doop-benchmarks/

    ## 设置 DOOP_OUT 参数
    # 检查环境变量$DOOP_OUT是否设置
    if [ -n "$DOOP_OUT" ]; then
    # 如果设置了，将$DOOP_OUT的值赋给$DOOP_OUT
    export DOOP_OUT="$DOOP_OUT"
    else
    # 如果未设置，将${DOOP_HOME}/out的值赋给$DOOP_OUT
    export DOOP_OUT="${DOOP_HOME}/out"
    fi
    # 输出最终的 $DOOP_OUT 的值
    echo "[+] DOOP_OUT: $DOOP_OUT"

    ## 设置子项目对象限制数字
    SplitLineNumber=6

    echo "[+] Finish: initialize the configuration file."
}

export -f config