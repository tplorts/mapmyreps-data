USA_DATA_BASE_DIR='dist-data'
S3_DATA_BUCKET='dev-data.mapmyreps.us'
FOLDER=congress

# The Node.js script downloads and condenses all json files from unitedstates.io
USA_DATA_BASE_DIR=$USA_DATA_BASE_DIR node download-congress.js

aws s3 cp $USA_DATA_BASE_DIR/$FOLDER s3://$S3_DATA_BUCKET/$FOLDER --recursive --acl public-read
