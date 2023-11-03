#!/bin/bash

###
 # @Author: fe1w0 xzasliuxinrong@gmail.com
 # @Date: 2023-10-29 17:25:28
 # @LastEditors: fe1w0 xzasliuxinrong@gmail.com
 # @LastEditTime: 2023-11-03 11:10:08
 # @FilePath: /DataSet/tools/overwrite.sh
 # @Description: 覆盖原doop中的 soufflé-rules
### 

function help() {
    echo "overwrite.sh [DOOP_HOME]"
    echo "\
    DOOP_HOME: doop 的地址"
}

if [[ $# -lt 1 ]]; then
    echo "Error: Not enough arguments"
    help
    exit 1
fi

function overwrite() {
    # 进入脚本当前地址
    cd "$(dirname "$0")"

    # backup
    if [ ! -d $DOOP_HOME/souffle-logic-backup ] ; then
        cp -r $DOOP_HOME/souffle-logic $DOOP_HOME/souffle-logic-backup
    fi

    # overwrite
    overwrite_rules=("entry-points.dl" "light-Class.dl" "light-reflection-glue.dl" "minimal-sources-and-sinks.dl" "app-only.dl", "native-reflection.dl")
    
    echo -e "overwrite-rules:"
    for overwrite_rule in "${overwrite_rules[@]}"
    do
        echo -e "\toverwrite-rule: $overwrite_rule"
    done

    # 设置入口点
    cp overwrite-rules/entry-points_b.dl $DOOP_HOME/souffle-logic/addons/open-programs/entry-points.dl

    # 反射
    cp overwrite-rules/light-Class.dl $DOOP_HOME/souffle-logic/main/reflection/light-Class.dl
    cp overwrite-rules/light-reflection-glue.dl $DOOP_HOME/souffle-logic/main/reflection/light-reflection-glue.dl

    # 优化分析速度
    cp overwrite-rules/minimal-sources-and-sinks.dl $DOOP_HOME/souffle-logic/addons/information-flow/minimal-sources-and-sinks.dl

    # 优化分析速度
    cp overwrite-rules/native-reflection.dl $DOOP_HOME/souffle-logic/main/reflection/native-reflection.dl

    echo "[+] Finish."
}


# main
DOOP_HOME=$1
overwrite