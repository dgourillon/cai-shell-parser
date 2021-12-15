#! /bin/sh

OUTPUT_DIR=kub_analysis_result

find k8s_resources -type f -name '*' | while read current_file; do
	echo "processing $current_file"
	TARGET_FILENAME=$(echo $current_file | awk -F '/' '{print $NF}')
	echo $TARGET_FILENAME
	cat $current_file | jq '[.["resource"]["parent"], .["name"], .["ancestors"][0]]  | @csv' | tr -d '"'> $OUTPUT_DIR/$TARGET_FILENAME.csv

done

cat resources/container.googleapis.com/Cluster | jq '[.["resource"]["parent"], .["name"], .["ancestors"][0]]  | @csv' > $OUTPUT_DIR/clusters.csv

#cat resources/container.googleapis.com/NodePool | jq '[.["resource"]["parent"],  .["name"], .["ancestors"][0]]' > $OUTPUT_DIR/nodepools.csv

#cat k8s_resources/k8s.io/Node | jq '[.["resource"]["parent"],  .["name"], .["ancestors"][0]]' > $OUTPUT_DIR/nodepools.csv


