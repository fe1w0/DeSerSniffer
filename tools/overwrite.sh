#!/bin/bash

###
 # @Author: fe1w0 xzasliuxinrong@gmail.com
 # @Date: 2023-10-29 17:25:28
 # @LastEditors: fe1w0 xzasliuxinrong@gmail.com
 # @LastEditTime: 2023-10-29 18:30:45
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
    cp -r $DOOP_HOME/souffle-logic $DOOP_HOME/souffle-logic-backup
    
    # overwrite
    overwrite_rules=("entry-points.dl" "light-Class.dl" "light-reflection-glue.dl" "minimal-sources-and-sinks.dl" "app-only.dl")
    
    echo -e "overwrite-rules:"
    for overwrite_rule in "${overwrite_rules[@]}"
    do
        echo -e "\toverwrite-rule: $overwrite_rule"
    done

    #
    cp overwrite-rules/entry-points.dl $DOOP_HOME/souffle-logic/addons/open-programs/entry-points.dl
    cp overwrite-rules/light-Class.dl $DOOP_HOME/souffle-logic/main/reflection/light-Class.dl
    cp overwrite-rules/light-reflection-glue.dl $DOOP_HOME/souffle-logic/main/reflection/light-reflection-glue.dl
    cp overwrite-rules/minimal-sources-and-sinks.dl $DOOP_HOME/souffle-logic/addons/information-flow/minimal-sources-and-sinks.dl
    cp overwrite-rules/app-only.dl $DOOP_HOME/souffle-logic/main/app-only.dl

    #
    echo "[+] Finish"
}


# main
DOOP_HOME=$1
overwrite