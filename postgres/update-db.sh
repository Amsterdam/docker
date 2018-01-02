#!/usr/bin/env bash
set -eu

if [ $# -eq 1 ]; then
    download-db.sh $1
elif [ $# -eq 2 ]; then
    download-db.sh $1 $2
else
    echo "Too many arguments or incorrect parameters. Please see the README for proper usage.";
fi

dropdb --if-exists -U postgres $1 || echo "Could not drop $1, continuing"
createuser -U postgres $1 || echo "Could not create $1, continuing"
createuser -U postgres $1_read || echo "Could not create $1, continuing"
SECONDS=0
pg_restore --if-exists -j 4 -c -C -d postgres -U postgres /tmp/$1_latest.gz

echo "Finished pg_restore $1"
duration=$SECONDS

echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
rm -f $1_latest.gz

echo "Refreshing materialized views for database: $1"
for mat_view in `psql -U postgres -d $1 -c "SELECT oid::regclass::text FROM pg_class where relkind='m'"   | tail -n +3 | head -n -2`
do
        refresh="REFRESH MATERIALIZED VIEW $mat_view"
        echo $refresh
        psql -U postgres -d $1 -c "$refresh"
done