#!/usr/bin/env bash
set -eu

if [ $# -eq 1 ]; then
    download-db.sh $1
elif [ $# -eq 2 ]; then
    download-db.sh $1 $2
else
    echo "Too many arguments or incorrect parameters. Please see the README for proper usage.";
fi

POSTGRES_USER=${POSTGRES_USER-postgres}

dropdb --if-exists -U $POSTGRES_USER $1 || echo "Could not drop $1, continuing"
createuser -U $POSTGRES_USER $1 || echo "Could not create $1, continuing"
createuser -U $POSTGRES_USER $1_read || echo "Could not create $1, continuing"
SECONDS=0

echo "Setting up schema"
pg_restore --if-exists -c -C -s -d postgres -U $POSTGRES_USER /tmp/$1_latest.gz

TABLES_TO_IMPORT=$(psql -U $POSTGRES_USER -d $1 -c "SELECT tablename::regclass::text FROM pg_catalog.pg_tables where tablename <> 'spatial_ref_sys' and schemaname='public' and tableowner='$1'" | tail -n +3 | head -n -2)

echo "Importing tables into the empty schema"
echo "1/2 Cascade-dropping tables to get rid of indices and views"
for import_table in $TABLES_TO_IMPORT
do
    echo " - drop table $import_table"
    psql -U $POSTGRES_USER -d $1 -c "drop table $import_table cascade"
done

echo "2/2 Importing table definitions and data only"
for import_table in $TABLES_TO_IMPORT
do
    echo " - import data to $import_table"
    pg_restore -U $POSTGRES_USER -c --if-exists --no-acl --no-owner --table=$import_table --schema=public /tmp/$1_latest.gz > ${import_table}_table.pg
    psql -U $POSTGRES_USER $1 < ${import_table}_table.pg
    rm -f ${import_table}_table.pg
done

echo "Reapplying indices and restoring (materialized) views"
pg_restore -s -d $1 -U $POSTGRES_USER /tmp/$1_latest.gz || echo "Ignore errors, we have only created objects that were (cascade)dropped"

echo "Clean up"
psql -U $POSTGRES_USER -d $1 -c "vacuum analyze"
rm -f $1_latest.gz

duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
