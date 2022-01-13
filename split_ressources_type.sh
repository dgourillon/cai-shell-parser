#! /bin/sh

SOURCE="input/export_resource.dump "
OUTPUT_DIR="output/raw_resources"

SUPPORTED_ASSET_URL="https://cloud.google.com/asset-inventory/docs/supported-asset-types"

mkdir $OUTPUT_DIR/raw_resources

for resource_type_asset in $(curl $SUPPORTED_ASSET_URL | grep -oi '[a-z]*.googleapis.com/[a-z]*'  | sort -u ) ; do
	echo "Generate $resource_type_asset file"
	ressource_type=$(echo $resource_type_asset | awk -F '/' '{print $1}' )
	mkdir -p $OUTPUT_DIR/$ressource_type
	grep $resource_type_asset $SOURCE > $OUTPUT_DIR/$resource_type_asset
done 


