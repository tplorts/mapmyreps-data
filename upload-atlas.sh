USA_DATA_BASE_DIR='dist-data'
S3_DATA_BUCKET='dev-data.mapmyreps.us'
ATLAS_PATH='geography/us-atlas-10m.json'
aws s3 cp "${USA_DATA_BASE_DIR}/${ATLAS_PATH}" "s3://${S3_DATA_BUCKET}/${ATLAS_PATH}" --acl public-read
