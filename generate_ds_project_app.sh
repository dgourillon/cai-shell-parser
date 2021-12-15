#!/bin/bash

TARGET_CSV=projects_services.csv
LEVELS_FOLDER=/home/dgourillon/jq_explorer/resources/levels/
RESOURCE_FOLDER=/home/dgourillon/jq_explorer/resources/
INITIAL_FILTER="folders/1080770203959"
#### define functions

get_folder_name(){
	#echo grep "cloudresourcemanager.googleapis.com/.*/$1" $RESOURCE_FOLDER/cloudresourcemanager.googleapis.com/*
	grep "\"name\":\"\/\/cloudresourcemanager.googleapis.com/$1" $RESOURCE_FOLDER/cloudresourcemanager.googleapis.com/Folder | jq '.resource["data"]["displayName"]' | tr -d '"' | tr -d '\n'

}

#### initialize output file

echo 'project_id,project_name,' > $TARGET_CSV

find resources/ -name "*" | sort | while read -r service; do
	printf "$service," >> $TARGET_CSV
done

echo "" >> $TARGET_CSV

grep "$INITIAL_FILTER" resources/cloudresourcemanager.googleapis.com/Project | while read -r project_line ; do

	project_id=$(echo $project_line | jq '.name' | awk -F '/' '{print $5}' | tr -d '"')
	used_services=$(grep -r "^.*ancestors.*projects\/$project_id" resources/ | awk -F ':' '{print $1}' | sort -u)
	project_name=$(echo $project_line | jq  '.resource["data"]["name"]')
	#echo $used_services | grep -i compute
        services_used_str=''
	printf "$project_id,$project_name" >> $TARGET_CSV
	find resources/ -name "*" | sort | while read -r service; do
		#echo check if "$service" is in $used_services
        	if echo "$used_services" | grep -i "$service" >> /dev/null
		then 
			#echo "yes"
			printf ",Y" >> $TARGET_CSV
			#echo $services_used_str
		else 
			#echo "non"
			printf ",N" >> $TARGET_CSV
		fi
	done
		
	echo "" >> $TARGET_CSV
done
