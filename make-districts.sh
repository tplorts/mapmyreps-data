STORAGE_DIR='temp'
USA_DATA_BASE_DIR='dist'
YEAR=2016
CONGRESS=115
CENSUS_OBJECT_NAME="cb_${YEAR}_us_cd${CONGRESS}_500k"

CENSUS_OBJECT_DIR="${STORAGE_DIR}/${CENSUS_OBJECT_NAME}"
if [ ! -d "$CENSUS_OBJECT_DIR" ]; then
  echo "Please download and unzip the census data, $CENSUS_OBJECT_NAME"
  exit 1
fi

GEOGRAPHY_DIR="${USA_DATA_BASE_DIR}/geography"
if [ ! -d "$GEOGRAPHY_DIR" ]; then
  mkdir $GEOGRAPHY_DIR
fi

GEOJSON_DIR="${STORAGE_DIR}/districts-geo"
if [ ! -d "$GEOJSON_DIR" ]; then
  mkdir $GEOJSON_DIR
fi

OUT_DATA_DIR="${GEOGRAPHY_DIR}/districts"
if [ ! -d "$OUT_DATA_DIR" ]; then
  mkdir $OUT_DATA_DIR
fi

SHAPEFILE_PATH="${CENSUS_OBJECT_DIR}/${CENSUS_OBJECT_NAME}.shp"
CD_JSON_PATH="${STORAGE_DIR}/congressional-districts.json"
CD_NDJSON_PATH="${STORAGE_DIR}/cd-features.ndjson"

# Convert the raw shape file from the census into GeoJSON
shp2json $SHAPEFILE_PATH -o $CD_JSON_PATH

# Create a newline-delimited version of the GeoJSON features
ndjson-split 'd.features' < $CD_JSON_PATH > $CD_NDJSON_PATH

# TODO: find a simple way to iterate through only the FIPS numbers
#       for regions that exist
for i in {1..99}
do
  FIPS_CODE=$(printf %02d $i)
  echo "State $FIPS_CODE"
  featuresGeoFile="${GEOJSON_DIR}/${FIPS_CODE}.json"
  featuresTopoFile="${OUT_DATA_DIR}/${FIPS_CODE}.json"


  # Organize all features by state, separated into per-state files
  # and convert each state's features back into GeoJSON
  ndjson-filter "d.properties.STATEFP === '$FIPS_CODE'" < $CD_NDJSON_PATH \
    | ndjson-reduce | ndjson-map '{type: "FeatureCollection", features: d}' > $featuresGeoFile

  # Convert the GeoJSON to TopoJSON and condense the data in multiple ways
  geo2topo districts=$featuresGeoFile | toposimplify -S 0.1 | topoquantize 1e5  > $featuresTopoFile

  # later: if we want only internal district borders (i.e. exclude the state border itself)
  # topomerge --mesh -f 'a !== b' districts=districts
done
