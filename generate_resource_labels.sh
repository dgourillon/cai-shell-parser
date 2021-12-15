#!/bin/sh


echo 'cluster_name,budgetary_responsible,cost_center,cost_center_number,division,environment,group'

cat $1 | while read -r cluster_line ; do
    #echo "Processing $cluster_line"
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
    echo "$CLUSTER_NAME,$budgetary_responsible,$cost_center,$cost_center_number,$division,$environment,$group" | tr -d '"'
done
