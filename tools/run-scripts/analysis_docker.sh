#!/bin/bash
# author: fe1w0

# 导入文件
source utils/config.sh
source utils/split_csv.sh
source utils/list_class.sh
source utils/run_analysis.sh
source utils/timer.sh
source utils/stats.sh

analysis() {

    # 初始化
    timer config

    # 启动 List Object 脚本
    timer list_class $ID $INPUT $DOOP_HOME $BASE_DIR $FuzzChainsPath $JAVA_HOME $JAVA_VERSION $JOBS

    # 划分任务，得到子任务数量, 得到
    timer split_csv $ID $SplitLineNumber

    # 按序处理分析任, ReturnCsvNumber
    for (( sub_id=1; sub_id<=$ReturnCsvNumber; sub_id++))
    do
        SubID=${ID}_${sub_id}
        timer run_analysis $SubID $INPUT $DOOP_HOME $BASE_DIR $FuzzChainsPath $JAVA_HOME $JAVA_VERSION $JOBS
    done

    # 分析阶段
    for (( sub_id=1; sub_id<=$ReturnCsvNumber; sub_id++))
    do
        SubID=${ID}_${sub_id}
        stats $SubID
    done
}

timer analysis
echo -e "[+] End Time: $(print_time)"