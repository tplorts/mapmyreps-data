USA_DATA_BASE_DIR='dist'
S3_DATA_BUCKET='dev-data.mapmyreps.us'
FOLDER=geography/districts

# aws s3 cp $USA_DATA_BASE_DIR/$FOLDER s3://$S3_DATA_BUCKET/$FOLDER --recursive --acl public-read
