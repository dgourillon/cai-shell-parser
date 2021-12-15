#! /bin/sh

RESOURCES_FOLDER=/home/dgourillon/jq_explorer/resources
LEVELS_FOLDER=/home/dgourillon/jq_explorer/levels
ORG_NAME=airbus.com
ORG_ID=$(grep $ORG_NAME $RESOURCES_FOLDER/cloudresourcemanager.googleapis.com/Organization | jq '.name' | awk -F '[/"]' '{print $6}' )
OUTPUT_CSV=$LEVELS_FOLDER/hierarchy.csv
echo '' > $OUTPUT_CSV

debug_log(){
	x=$2; 
	echo $1 | awk -v x=$x '{printf "%" x "s%s\n", "", $0}'
}


analyse_folder_level () {
	current_level=$1
	current_string=$2
	parent_folder=$3
	current_level_file=$LEVELS_FOLDER/$current_level
	lowest_level=$(ls $LEVELS_FOLDER | sort -n | tail -1)
	debug_log "read the file $current_level_file under the parent $current_string " $current_level
	grep "$parent_folder" $current_level_file | while read -r current_folder ; do
		current_folder_name=$(echo $current_folder | jq '.name' | awk -F '/' '{print $5}' | tr -d '"')
		current_folder_displayName=$(echo $current_folder | jq '.resource["data"]["displayName"]' | tr -d '"')
		write_str=$(echo $current_string,$current_folder_displayName)
		#echo new write str :  $write_str
		if [ $current_level -eq $lowest_level ]
		then
			#echo "$current_level level is last"
			echo  "output : $write_str" >> $OUTPUT_CSV
		else
			debug_log "get the childs for $current_folder_displayName" "$currrent_level"
			analyse_folder_level  $(($current_level+1)) "$write_str" "$current_folder_name"
	        fi

	done
}


mkdir $LEVELS_FOLDER
rm  $LEVELS_FOLDER/*

grep $ORG_ID $RESOURCES_FOLDER/cloudresourcemanager.googleapis.com/Folder | while read -r project_line ; do
    #echo "Processing $project_line"
    CURRENT_LEVEL=$(echo $project_line | jq '.ancestors | join("|")' | awk -F '|' '{print NF}')
    echo $project_line >> $LEVELS_FOLDER/$CURRENT_LEVEL
done

analyse_folder_level 2 $ORG_NAME $ORG_ID

echo $ORG_ID



