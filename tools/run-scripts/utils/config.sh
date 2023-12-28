#!/bin/bash
# author: fe1w0

dir="$(dirname "$BASH_SOURCE")"

# 加载 overwrite 模块
source ${dir}/overwrite.sh

# 加载 生成analysis.dl文件 模块
source ${dir}/add_custom_text_to_file.sh

# 加载 doop 配置模块
source ${dir}/config/doop_config.sh

# 函数：初始化
config() {

    # 设置 DOOP 参数
    doop_config

    # 设置 日志
    log_config

    # 创建 LOG
    echo -e "[+] $(print_time) Start: $ID, $INPUT, $CurrentLOG, $TmpLog" | tee $CurrentLOG

    ### 生成 最终 analysis.dl 文件
    add_custom_text_to_file ${BASE_DIR}/tools/custom-rules/simple-analysis.dl ${BASE_DIR}/tools/custom-rules/analysis.dl $MaxNumberMaybeTaintedField
    echo -e "\t[+] $(print_time) Finish: Generate analysis.dl" | tee -a $CurrentLOG

    ## overwrite doop
    overwrite $DOOP_HOME
    echo -e "\t[+] $(print_time) Finish: OverWrite" | tee -a $CurrentLOG
        
    # 输出最终的 $DOOP_OUT 的值
    echo "[+] $(print_time) DOOP_OUT: $DOOP_OUT" | tee -a $CurrentLOG

    # 完成分析配置过程
    echo "[+] $(print_time) Finish: Configuration." | tee -a $CurrentLOG
}

# 函数: 设置日志
log_config() {
    ## LOG 配置文件
    mkdir -p ${DOOP_OUT}/log/
    CurrentLOG=${DOOP_OUT}/log/${ID}.log
}

export -f config