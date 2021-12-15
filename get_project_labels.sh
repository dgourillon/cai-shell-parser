#! /bin/sh

PROJECT_NUMBER=$1
PROJECT_RESOURCE_FILE=/home/dgourillon/jq_explorer/resources/cloudresourcemanager.googleapis.com/Project

grep $PROJECT_NUMBER $PROJECT_RESOURCE_FILE |  while read -r cluster_line ; do

done
