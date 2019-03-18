#!/usr/bin/env bash
set -eu
set -x

cd /tmp
rm -f $1

if [ $# -eq 1 ] && [ ! -f $1_latest.gz ]; then
    echo "User parameter not found: Using download for internal imports"
    wget -nc https://admin.data.amsterdam.nl/postgres/$1_latest.gz
elif [ $# -eq 2 ] && [ ! -f $1_latest.gz ]; then
    echo "User parameter found: Using download for developers"
    scp -i ~/.ssh/datapunt.key $2@admin.data.amsterdam.nl:/mnt/backup_postgres/$1_latest.gz .
fi
