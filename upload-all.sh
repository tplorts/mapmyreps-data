USA_DATA_BASE_DIR='dist-data'
if [ ! -d "$USA_DATA_BASE_DIR" ]; then
  echo "no directory here named $USA_DATA_BASE_DIR.  Did you already prepare the data?"
  exit 1
fi

if [ "$1" == "" ]; then
  echo "Please specify to which data bucket you want to upload."
  exit 1
fi

DATA_BUCKET_ID=$1

# FIXME: regex below not properly matching any of the three names
# if [[ ! $DATA_BUCKET_ID =~ '(dev-|staging-|)data' ]]; then
#   echo "$DATA_BUCKET_ID is not one of the available data buckets."
#   echo "Choose one of: data, staging-data, or dev-data."
#   exit 1
# fi

S3_DATA_BUCKET="$DATA_BUCKET_ID.mapmyreps.us"

aws s3 cp $USA_DATA_BASE_DIR/ s3://$S3_DATA_BUCKET/ --recursive --acl public-read
