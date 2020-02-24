#!/usr/bin/env bash
set -eu
set -x

cd /tmp
rm -f $1

ENVIRONMENT=${ENVIRONMENT:-acceptance}
if [ "${ENVIRONMENT}" = "production" ]; then
        echo "Directly downloading production databases is no longer possible"
fi

if [ ! -f $1_latest.gz ]; then
    echo "$1_latest.gz file does not exist, downloading backup"

    wget -nc https://admin.data.amsterdam.nl/postgres/$1_latest.gz
fi
