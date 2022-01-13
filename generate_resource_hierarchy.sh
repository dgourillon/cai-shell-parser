#! /bin/sh

SOURCE="input/export_resource.dump "
RAW_RESOURCES="output/raw_resources"
OUTPUT_DIR="output/hierarchy_resources"

mkdir $OUTPUT_DIR


get_name_from_id() {
    requested_input=$1
    type=$(echo $requested_input | awk -F '"/"|"_"' '{print $1}')
    echo $type
}

convert_id_to_display_name(){
    for current_path in $(find $OUTPUT_DIR -type d ); do
        echo $current_path
        if 1 #$(echo $current_path) #| grep 'organizations\|folder\|project')
        then
            current_id=$(echo $current_path | awk -F '/' '{print $NF}')
        fi
    done
}


generate_folder_structure() {
for current_folder in $(grep cloudresourcemanager.googleapis.com/Project $SOURCE); do
    folder_id=$(echo $current_folder | jq '.resource["data"]["name"]')
    ancestors=$(echo $current_folder | jq '.ancestors | @csv' | tr -d '\\\"' | awk -F ',' '{for(i=NF;i>1;i--)printf "%s ",$i;printf "%s",$1;print ""}' | tr '/' '_' | tr ' ' '/')
    mkdir -p $OUTPUT_DIR/$ancestors
done
}

generate_folder_structure
convert_id_to_display_name