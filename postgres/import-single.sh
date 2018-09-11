#!/usr/bin/env bash
set -eu

# this script can be used if you want to import a database in a single thread, and a single commit

if [ $# -eq 1 ]; then
    download-db.sh $1
elif [ $# -eq 2 ]; then
    download-db.sh $1 $2
else
    echo "Too many arguments or incorrect parameters. Please see the README for proper usage.";
fi

POSTGRES_USER=${POSTGRES_USER-postgres}

createuser -U $POSTGRES_USER $1 || echo "Could not create $1, continuing"
createuser -U $POSTGRES_USER $1_read || echo "Could not create $1, continuing"
createuser -U $POSTGRES_USER basiskaart_read || echo "Could not create basiskaart_read, continuing"
SECONDS=0
pg_restore --single-transaction -j 1 -d $1 -U $POSTGRES_USER /tmp/$1_latest.gz

echo "Finished pg_restore $1"
duration=$SECONDS

echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
rm -f $1_latest.gz
