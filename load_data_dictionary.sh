#!/usr/bin/env bash

#set -x
set -e
set -o pipefail

fail() {
    echo "== Load Datamart Descriptions Failed (see ${LOG_FILE} file) =="
    exit 1
}

success() {
    exit 0
}

run() {
    local base="$1"
    python utilities/run.py "$PSQL" $PSQL_OPTIONS \
        --set=schema="$_DB_SCHEMA" \
        -f "${base}.sql" >> "${LOG_FILE}" 2>&1 \
        || return 1
}

. ./checkenv.sh || fail

LOG_FILE="${LOG_FOLDER}/build_data_dictionay.log"

echo "Create ${INSTALLATION_FOLDER}/build_data_dictionary.sql"
python utilities/build_data_dictionary.py sql > build_data_dictionary.sql || fail

echo "Load ${INSTALLATION_FOLDER}/build_data_dictionary.sql"
run build_data_dictionary || fail

success
