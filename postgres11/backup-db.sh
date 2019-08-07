#!/usr/bin/env bash

set -u
set -e
set -x

echo 0.0.0.0:5432:$1:$1:insecure > ~/.pgpass
chmod 600 ~/.pgpass

pg_dump -Fc -h 0.0.0.0 -U $1 $1 > /tmp/backups/database.dump
