#!/bin/sh

K8S_CLUSTER_FILE=/home/dgourillon/jq_explorer/resources/container.googleapis.com/Cluster 
FOLDERS_FILE=/home/dgourillon/jq_explorer/resources/cloudresourcemanager.googleapis.com/Folder 
FOLDER_ID=$(grep "Airbus DS" $FOLDERS_FILE | jq '.name' | awk -F '[/"]' '{print $6}' )

TARGET_CSV="k8s_clusters.csv"
echo 'cluster_name,budgetary_responsible,cost_center,cost_center_number,division,environment,group,cluster_ip,service_ip' > $TARGET_CSV

grep $FOLDER_ID $K8S_CLUSTER_FILE | while read -r cluster_line ; do
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
    cluster_ip_range=$( echo $cluster_line | jq '.resource["data"]["clusterIpv4Cidr"]')
    service_ip_range=$( echo $cluster_line | jq '.resource["data"]["servicesIpv4Cidr"]' )

    #echo $LABELS | jq
    echo "$CLUSTER_NAME,$budgetary_responsible,$cost_center,$cost_center_number,$division,$environment,$group,$cluster_ip_range,$service_ip_range" | tr -d '"'  >> $TARGET_CSV
done
