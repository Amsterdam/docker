#!/usr/bin/env bash
set -eu

# Do some variables
ADMIN_HOST=admin.datapunt.amsterdam.nl
DATATYPE=$1
INDICES=${@:2}
TEMPDIR=/tmp/${DATATYPE}
ELFILE=$1.gz

# Create dir's, clean, download, extract and set rights
mkdir -p ${TEMPDIR}
rm -Rf ${TEMPDIR}/*

cd ${TEMPDIR}
if [ ! -v LOCAL ]; then
    wget -nc https://${ADMIN_HOST}/elastic/${ELFILE}
else
    scp -i ~/.ssh/datapunt.key $2@${ADMIN_HOST}:/mnt/elastic-acc/${ELFILE} .
fi

tar xzvf ${ELFILE}
chown -R elasticsearch:elasticsearch ${TEMPDIR}

# Wait for Elastic to come up
while ! nc -z localhost 9200
do
        printf "Waiting for elasticsearch...\n"
        sleep 0.5
done


# Try removing stale snapshot definitions and delete existing indices. Do not fail when they do no exist (yet)
set +e
curl -s -v -f -XDELETE http://localhost:9200/_snapshot/${DATATYPE} || true

for indx in ${INDICES}
do
    curl -s -v -f -XDELETE http://localhost:9200/${indx}/ || true
done
set -e

# Register backup location as a snapshot repo with ES
curl -s -v -f -XPUT http://localhost:9200/_snapshot/${DATATYPE} -d "{ \"type\": \"fs\", \"settings\": { \"location\": \"\/tmp\/$DATATYPE\" }}"

# Restore the snapshot from the newly defined repo
printf "\nRestoring Elastic\n\n"
curl -s -v -f -XPOST http://localhost:9200/_snapshot/${DATATYPE}/${DATATYPE}/_restore\?pretty&wait_for_completion=true
printf "\n\nFinished Elastic Restore\n\n"
sleep 1

#Give ES some time to finish. Even though we already waited for completion it still does some housekeeping in the background
curl -XGET http://localhost:9200/_cluster/health?wait_for_status=yellow\&wait_for_relocating_shards=0\&wait_for_initializing_shards=0\&pretty\&timeout=320s

printf "\nCleaning up\n"
# Remove the snapshot repo from ES
curl -s -v -f -XDELETE http://localhost:9200/_snapshot/${DATATYPE}

# Delete the downloaded snapshot from disk.
# Doing this and the previous step without waiting seems to make imports fail sometimes.
rm -rf ${TEMPDIR}

printf "\n\n\nDONE\n"