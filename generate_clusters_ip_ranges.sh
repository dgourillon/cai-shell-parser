#!/bin/sh

SOURCE_CLUSTER_FILE=/home/dgourillon/jq_explorer/resources/container.googleapis.com/Cluster

cat  $SOURCE_CLUSTER_FILE | while read -r line_cluster ; do

	echo $line_cluster | jq

done;

