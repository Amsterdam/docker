#!/usr/bin/env bash
set -eu

# Do some variables
ADMIN_HOST=admin.datapunt.amsterdam.nl
DATATYPE=$1
TEMPDIR=/tmp/${DATATYPE}
ELFILE=$1.gz

# Create dir's, clean, download, extract and set rights
mkdir -p ${TEMPDIR}
rm -Rf ${TEMPDIR}/*

cd ${TEMPDIR}

if [ $# -eq 1 ]; then
    echo "User parameter not found: Using download for internal imports"
    wget -nc https://${ADMIN_HOST}/elastic/${ELFILE}
else
    echo "User parameter found: Using download for developers"
    scp -i ~/.ssh/datapunt.key $2@${ADMIN_HOST}:/mnt/elastic-acc/${ELFILE} .
fi

tar xzvf ${ELFILE}
chown -R elasticsearch:elasticsearch ${TEMPDIR}

# Wait for Elastic to come up
while ! curl --output /dev/null --silent --head --fail http://localhost:9200/
do
        printf "Waiting for elasticsearch...\n"
        sleep 0.5
done

# Try removing stale snapshot definitions. Do not fail when they do no exist (yet)
set +e
curl -s -v -f -XDELETE "http://localhost:9200/_snapshot/${DATATYPE}" || true
set -e

# Register backup location as a snapshot repo with ES
curl -XPUT "http://localhost:9200/_snapshot/${DATATYPE}?pretty" -H 'Content-Type: application/json' -d"
{
  \"type\": \"fs\",
  \"settings\": {
    \"location\": \"/tmp/${DATATYPE}/\"
  }
}
"
sleep 2

# Restore the snapshot from the newly defined repo
printf "\nRestoring Elastic\n\n"

curl -XPOST "http://localhost:9200/_snapshot/${DATATYPE}/${DATATYPE}/_restore?pretty&wait_for_completion=true"

printf "\n\nFinished Elastic Restore\n\n"
sleep 2

#Give ES some time to finish. Even though we already waited for completion it still does some housekeeping in the background
curl -XGET http://localhost:9200/_cluster/health?wait_for_status=yellow\&wait_for_no_relocating_shards=true\&pretty\&timeout=320s

printf "\nCleaning up\n"
# Remove the snapshot repo from ES
curl -s -v -f -XDELETE http://localhost:9200/_snapshot/${DATATYPE}

# Delete the downloaded snapshot from disk.
# Doing this and the previous step without waiting seems to make imports fail sometimes.
rm -rf ${TEMPDIR}

printf "\n\n\nDONE\n"