#!/bin/sh

SOURCE="input/export_resource.dump "
INPUT_FOLDER="output/raw_resources"
OUTPUT_FILE="output/services_usage.csv"

SUPPORTED_ASSET_URL="https://cloud.google.com/asset-inventory/docs/supported-asset-types"

services_list=$(curl $SUPPORTED_ASSET_URL | grep -oi '[a-z]*.googleapis.com/[a-z]*'  | awk -F '/' '{print $1}' | sort -u)

printf "project_number,project_id," > $OUTPUT_FILE

for current_service in $services_list; do
    printf "$current_service" >> $OUTPUT_FILE
done
echo "" >> $OUTPUT_FILE
for current_project_str in $(jq '. | "\(.name),\(.resource["data"]["projectId"]) "' $INPUT_FOLDER/cloudresourcemanager.googleapis.com/Project ) ; do

    current_project_name=$(echo $current_project_str | awk -F ',' '{print $1}' | awk -F '/' '{print $4 "/" $5}' )
    current_project_id=$(echo $current_project_str | awk -F ',' '{print $2}')
    printf "$current_project_name,$current_project_id," >> $OUTPUT_FILE
    services_str=""
    for current_service in $services_list; do
        #echo "check if $current_service in $current_project_name"
        if grep -r $current_project_name $INPUT_FOLDER/$current_service > /dev/null
        then 
            services_str="${services_str}Y,"
        else
            services_str="${services_str}N,"
        fi
    done
    echo $services_str | tr -d '\n' >> $OUTPUT_FILE
    echo "" >> $OUTPUT_FILE
done
