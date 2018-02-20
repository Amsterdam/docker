#!/usr/bin/env bash
set -eu

# Wait for Elastic to come up
while ! curl --output /dev/null --silent --head --fail http://localhost:9200/
do
        printf "Waiting for elasticsearch...\n"
        sleep 0.5
done

# delete existing indices. Do not fail when they do no exist
set +e
curl -s -v -f -XDELETE "http://localhost:9200/*/" || true
set -e

#Give ES some time to finish. Even though we already waited for completion it still does some housekeeping in the background
curl -XGET http://localhost:9200/_cluster/health?wait_for_status=yellow\&wait_for_no_relocating_shards=true\&pretty\&timeout=320s

printf "\n\n\nDONE\n"