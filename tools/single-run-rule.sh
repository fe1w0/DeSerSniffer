INPUT_DIR
OUTPUT_DIR=/home/liuxr/Project/SoftwareAnalysis/DataSet/output
RULE_FILE=

souffle -F ${INPUT_DIR} -D ${OUTPUT_DIR} ${RULE_FILE} -j 30