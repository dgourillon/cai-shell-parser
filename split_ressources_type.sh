#! /bin/sh

SOURCE=$1
OUTPUT_DIR=/home/dgourillon/jq_explorer/resources


curl https://cloud.google.com/asset-inventory/docs/supported-asset-types | grep -oi '[a-z]*.googleapis.com/[a-z]*'  | sort -u > $OUTPUT_DIR/ressource_types

mkdir $OUTPUT_DIR/ressources_folder

while read line; do
	echo "Generate $line file"
	ressource_type=$(echo $line | awk -F '/' '{print $1}' )
	mkdir -p $OUTPUT_DIR/$ressource_type
	grep $line $SOURCE > $OUTPUT_DIR/$line
done < $OUTPUT_DIR/ressource_types
