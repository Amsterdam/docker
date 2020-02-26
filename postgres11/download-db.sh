#!/usr/bin/env bash
set -eu
set -x

TARGET_FILE="/tmp/$1_latest.gz"

ENVIRONMENT=${ENVIRONMENT:-acceptance}
DOWNLOAD_URL="https://admin.data.amsterdam.nl/postgres/${1}_latest.gz"

if [[ "${ENVIRONMENT}" = "production" ]]; then
        echo "Directly downloading production backup is only possible from the CICD pipelines"
        DOWNLOAD_URL="https://admin.data.amsterdam.nl/postgres_prod/${1}_latest.gz"
fi

if [[ ! -f "${TARGET_FILE}" ]]; then
    echo "$1_latest.gz file does not exist, downloading backup"

    wget -O "${TARGET_FILE}" -nc "${DOWNLOAD_URL}"
fi
