#!/bin/bash

RESOURCES_FOLDER=/home/dgourillon/jq_explorer/resources

get_folder_name(){
	if [[ $1 == *"folder"* ]]; then
		grep "\"name\":\"\/\/cloudresourcemanager.googleapis.com/$1" $RESOURCES_FOLDER/cloudresourcemanager.googleapis.com/Folder | jq '.resource["data"]["displayName"]' | tr -d '"' | tr -d '\n'
	fi
	if [[ $1 == *"organization"* ]]; then
	grep "\"name\":\"\/\/cloudresourcemanager.googleapis.com/$1" $RESOURCES_FOLDER/cloudresourcemanager.googleapis.com/Organization | jq '.resource["data"]["displayName"]' | tr -d '"' | tr -d '\n'
	fi
	#if [[ $1 == *"project"* ]]; then
	#grep "\"name\":\"\/\/cloudresourcemanager.googleapis.com/$1" $RESOURCES_FOLDER/cloudresourcemanager.googleapis.com/Project | jq '.resource["data"]["name"]' | tr -d '"' | tr -d '\n'
	#fi

}

analyze_file_ancestors(){
	file_to_analyse=$1
	cat $1 | while read -r line ; do
	    #echo "Processing $project_line"
	    	name=$(echo $line | jq '.name')
		ancestors=$(echo $line | jq '.ancestors')
		ancestors_line_result="$name,"
		ancestors_list=$(echo $line | jq '.ancestors' | grep -v '\[\|]' | tr -d '" ,')
		while read -r ancestor_line ; do
			ancestor_line_name=$(get_folder_name $ancestor_line)
			ancestors_line_result=$(echo "$ancestors_line_result,$ancestor_line,$ancestor_line_name")
		done <<<$(echo -e "$ancestors_list") 
		echo "$ancestors_line_result" |  awk -F ',' '{for(i=NF;i>=1;i--) printf "%s,", $i;print ""}'
	done

}

analyze_file_ancestors $1  

