#!/usr/bin/env bash

# set -x
set -e
set -o pipefail

fail() {
  echo "== Load Failed (see $LOG_FILE) =="
  cd "$ORIGINAL_DIR"
  exit 1
}

success() {
  cd "$ORIGINAL_DIR"
  echo "== Load Done: schema '${_DB_SCHEMA}', database '${_DB_NAME}', host '${_DB_HOST}' =="
  exit 0
}

load() {
  echo "Load ${VIEWS_FOLDER}/$1.sql"
  python utilities/run.py "$PSQL" $PSQL_OPTIONS --set=schema="${_DB_SCHEMA}" -f "${VIEWS_FOLDER}/$1.sql" >> "$LOG_FILE" 2>&1 || fail
}

# Setup env
. ./checkenv.sh || fail

# initializations
ORIGINAL_DIR="$(pwd)"
cd "$(dirname "$0")" || exit 1
LOG_FILE="${LOG_FOLDER}/DATAPOND_VIEWS.log"

# Initialize log file
: > "$LOG_FILE"

# Load views
load DIM_CISQ
load DIM_OWASP_2017
load BASEDATA_FLAT
load COMPLETE_FLAT
load DATAPOND_BASEDATA
load DATAPOND_VIOLATIONS
load DATAPOND_AP
load DATAPOND_EXCLUSIONS
load DATAPOND_PATTERNS

success



