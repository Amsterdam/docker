#!/bin/bash

set -u   # crash on missing env variables
set -e   # stop on any error
set -x

chmod -R 777 /tmp/backups

# remove old junk if any
rm -rf /tmp/backups/*

echo "Backing up $1 indicess: $2"

docurl() {
	curl -H "Content-Type:application/json;" --trace-ascii -f -XPUT "$@"
}

docurl http://elasticsearch:9200/_snapshot/backup  -d '
{
  "type": "fs",
  "settings": {
      "location": "/tmp/backups" }
}'


docurl  http://elasticsearch:9200/_snapshot/backup/$1?wait_for_completion=true -d '
{ "indices": "'"$2"'"}'


chmod -R 777 /tmp/backups
