#!/usr/bin/env bash
set -eu
set -x

cd /tmp
rm -f $1

ENVIRONMENT=${ENVIRONMENT:-acceptance}
if [ $# -eq 1 ] && [ ! -f $1_latest.gz ]; then
    echo "User parameter not found: Using download ${ENVIRONMENT} for internal imports"
    if [ "${ENVIRONMENT}" = "production" ]; then
        wget -nc https://admin.data.amsterdam.nl/postgres_prod/$1_latest.gz
    else
        wget -nc https://admin.data.amsterdam.nl/postgres/$1_latest.gz
    fi
elif [ $# -eq 2 ] && [ ! -f $1_latest.gz ]; then
    echo "User parameter found: Using download for developers"
    scp -i ~/.ssh/datapunt.key $2@admin.data.amsterdam.nl:/mnt/backup_postgres/$1_latest.gz .
fi
