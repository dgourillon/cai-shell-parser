#! /bin/sh

SOURCE=export_resource.dump
OUTPUT_DIR=k8s_resources

grep 'k8s' $SOURCE | jq '.asset_type' | grep k8s | sort -u > k8s_resources_list

while read line; do
        echo "Generate $line file"
        resource_type=$(echo $line | awk -F '/' '{print $1}' | tr -d '"')
	target_file=$(echo $line | tr -d '"')
	echo $resource_type
        mkdir -p k8s_resources/$resource_type
        grep $line $SOURCE > $OUTPUT_DIR/$target_file
done < k8s_resources_list

