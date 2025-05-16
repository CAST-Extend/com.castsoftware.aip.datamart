#!/bin/sh

# Save the current directory (equivalent of pushd)
ORIGINAL_DIR="$(pwd)"
cd "$(dirname "$0")" || exit 1

# Load environment
. ./setenv.sh || fail
. ./checkenv.sh || fail

# Define the log file
LOG_FILE="$LOG_FOLDER/schema_upgrade.log"
: > "$LOG_FILE"  # truncate log file

# Error handler
fail() {
  cd "$ORIGINAL_DIR"
  echo "== Schema upgrade Failed (see $LOG_FILE file) =="
  exit 1
}

# Success handler
success() {
  cd "$ORIGINAL_DIR"
  echo "== Schema upgrade Done: schema '$_DB_SCHEMA', database '$_DB_NAME', host '$_DB_HOST' =="
  exit 0
}

# Upgrade schema
echo "Upgrade schema"
python utilities/run.py "$PSQL" $PSQL_OPTIONS --set=schema="$_DB_SCHEMA" -f upgrade_schema.sql >> "$LOG_FILE" 2>&1 || fail

# Load data dictionary
./load_data_dictionary || fail

# Done
success
