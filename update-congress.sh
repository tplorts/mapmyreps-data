if [ "$1" == "" ]; then
  echo "Please specify to which data bucket you want to upload."
  exit 1
fi

USA_DATA_BASE_DIR='dist-data'
if [ ! -d "$USA_DATA_BASE_DIR" ]; then
  mkdir $USA_DATA_BASE_DIR
fi

cd $USA_DATA_BASE_DIR
FOLDER=congress
if [ ! -d "$FOLDER" ]; then
  mkdir $FOLDER
fi
cd ..

VALID_BUCKET_IDS=(dev-data staging-data data)
BUCKET_REGEX=$(IFS=\| eval 'echo "${VALID_BUCKET_IDS[*]}"')
DATA_BUCKET_ID=$1
if [[ ! $DATA_BUCKET_ID =~ ^$BUCKET_REGEX$ ]]; then
  echo "'$DATA_BUCKET_ID' is not one of the available buckets."
  echo "Choose one of: ${VALID_BUCKET_IDS[*]}."
  exit 1
fi
S3_DATA_BUCKET="$DATA_BUCKET_ID.mapmyreps.us"
echo "Bucket: $S3_DATA_BUCKET"


# The Node.js script downloads and condenses all json files from unitedstates.io
USA_DATA_BASE_DIR=$USA_DATA_BASE_DIR node download-congress.js

aws s3 cp $USA_DATA_BASE_DIR/$FOLDER s3://$S3_DATA_BUCKET/$FOLDER --recursive --acl public-read
