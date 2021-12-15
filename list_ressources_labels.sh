#!/bin/sh

RESOURCE_TYPE=$1
RESOURCE_FOLDER=/home/dgourillon/jq_explorer/resources


RESOURCE_FILE=$RESOURCE_FOLDER/$RESOURCE_TYPE 
FOLDERS_FILE=$RESOURCE_FOLDER/cloudresourcemanager.googleapis.com/Folder 
FOLDER_ID=$(grep "Airbus DS" $FOLDERS_FILE | jq '.name' | awk -F '[/"]' '{print $6}' )

TARGET_CSV="$RESOURCE_FOLDER/$RESOURCE_TYPE.csv"
echo 'cluster_name,budgetary_responsible,cost_center,cost_center_number,division,environment,group' > $TARGET_CSV

echo grep folder ID : grep "Airbus DS" $FOLDERS_FILE \| jq '.name' \| awk -F '[/"]' '{print $6}'   
echo grep  folder_id $FOLDER_ID resource $RESOURCE_FILE 

grep $FOLDER_ID $RESOURCE_FILE | while read -r cluster_line ; do
    echo "Processing $cluster_line"
    CLUSTER_NAME=$(echo $cluster_line | jq '.name')
    PROJECT=$( echo $cluster_line | jq '.ancestors' | grep projects  | awk -F '["/]' '{print $3}')
    LABELS=$(/home/dgourillon/jq_explorer/get_project_labels.sh $PROJECT | tr '\n' ' ')
    budgetary_responsible=$(echo $LABELS | jq '.budgetary_responsible')
    cost_center=$(echo $LABELS | jq '.cost_center')
    cost_center_number=$(echo $LABELS | jq '.cost_center_number')
    division=$(echo $LABELS | jq '.division')
    environment=$(echo $LABELS | jq '.environment')
    group=$(echo $LABELS | jq '.group')
    #echo $LABELS | jq
    echo "$CLUSTER_NAME,$budgetary_responsible,$cost_center,$cost_center_number,$division,$environment,$group" | tr -d '"'  >> $TARGET_CSV
done
