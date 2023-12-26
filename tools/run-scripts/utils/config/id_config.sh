#!/bin/bash
# author: fe1w0

# 函数: ID 设置
id_config() {
    # 检测项目
    ID=com_alibaba_nacos_nacos_client_2_3_0
    INPUT=com.alibaba.nacos:nacos-client:2.3.0

    # ID=com_alibaba_fastjson_2_0_42
    # INPUT=com.alibaba:fastjson:2.0.42

    ID=org_apache_flink_flink_java_1_18_0
    INPUT=org.apache.flink:flink-java:1.18.0

    ID=org_seleniumhq_selenium_selenium_java_4_15_0
    INPUT=org.seleniumhq.selenium:selenium-java:4.15.0

    ID=org_pytorch_torchserve_plugins_sdk_0_0_5
    INPUT=org.pytorch:torchserve-plugins-sdk:0.0.5

    ID=com_yahoo_vespa_vespajlib_8_277_17
    INPUT=com.yahoo.vespa:vespajlib:8.277.17

    ID=com_yahoo_vespa_annotations_8_265_12
    INPUT=com.yahoo.vespa:annotations:8.265.12

    ID=io_vertigo_vertigo_extensions_4_1_0
    INPUT=io.vertigo:vertigo-extensions:4.1.0
}

export -f id_config