#!/bin/sh

INPUT_FOLDER="output/raw_resources"
OUTPUT_FILE="output/hierarchy.txt"

jq '. | "\(.resource["data"]["name"]) \(.resource["data"]["displayName"]) "'   $INPUT_FOLDER/cloudresourcemanager.googleapis.com/Folder > folder_map
jq '. | "\(.name) \(.resource["data"]["projectId"]) "' $INPUT_FOLDER/cloudresourcemanager.googleapis.com/Project > project_map
jq '. | "\(.name) \(.resource["data"]["displayName"]) "' $INPUT_FOLDER/cloudresourcemanager.googleapis.com/Organization  > org_map
echo " Org_name / Folder 1 / Folder 2 / .... / Project ID" > $OUTPUT_FILE

for current_line in $(jq '. | "\(.resource["data"]["name"])_\(.ancestors) " ' $INPUT_FOLDER/cloudresourcemanager.googleapis.com/Project | sed -E 's/\"|\[|\]|\\//g' ); do
    project=$(echo $current_line | awk -F '_' '{print $1}')
    ancestors=$(echo $current_line | awk -F '_' '{print $2}')
    ancestors_names=""
    for str in ${ancestors//,/ } ; do 

        to_add=""
        [[ $str =~ ^.*folder.*$ ]] && to_add=$(grep $str  folder_map | awk '{print $2}')
        [[ $str =~ ^.*project.*$ ]] && to_add=$(grep $str  project_map | awk '{print $2}')
        [[ $str =~ ^.*org.*$ ]] && to_add=$(grep $str  org_map | awk '{print $2}')
        ancestors_names="$to_add / $ancestors_names"
    done
    echo "$ancestors_names" >> $OUTPUT_FILE
done

rm folder_map
rm project_map
rm org_map
cat $OUTPUT_FILE | sort