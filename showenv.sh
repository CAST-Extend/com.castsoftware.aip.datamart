#!/usr/bin/env bash

# set -x
set -e
set -o pipefail

# Save current directory (optional)
ORIGINAL_DIR="$(pwd)"
cd "$(dirname "$0")" || exit 1

# Load environment
. ./checkenv.sh || { echo "Failed to source checkenv.sh"; exit 1; }

echo
echo "INSTALLATION_FOLDER=$INSTALLATION_FOLDER"
echo
echo "REST API"
echo "========"

if [ -n "$CREDENTIALS" ]; then
  echo "CREDENTIALS=*****"
else
  echo "CREDENTIALS="
fi

if [ -n "$APIUSER" ]; then
  echo "APIUSER=*****"
else
  echo "APIUSER="
fi

if [ -n "$APIKEY" ]; then
  echo "APIKEY=*****"
else
  echo "APIKEY="
fi

echo "DEFAULT_DOMAIN=$DEFAULT_DOMAIN"
echo "DEFAULT_ROOT=$DEFAULT_ROOT"
echo "HD_ROOT=$HD_ROOT"

# Loop from 0 to 9 and print ED_ROOT[n] if defined
for n in $(seq 0 9); do
  eval "value=\${ED_ROOT$n}"
  echo "ED_ROOT[$n]=$value"
done

echo "JOBS=$JOBS"
echo
echo
echo "EXTRACTION SCOPE"
echo "================"
echo "EXTRACT_DATAPOND=$EXTRACT_DATAPOND"
echo "EXTRACT_TECHNO=$EXTRACT_TECHNO"
echo "EXTRACT_MOD=$EXTRACT_MOD"
echo "EXTRACT_SRC=$EXTRACT_SRC"
echo "EXTRACT_USR=$EXTRACT_USR"
echo "EXTRACT_ZERO_WEIGHT=$EXTRACT_ZERO_WEIGHT"
echo "DEBUG=$DEBUG"
echo
echo "TARGET DATABASE"
echo "==============="
echo "_DB_HOST=$_DB_HOST"
echo "_DB_PORT=$_DB_PORT"
echo "_DB_NAME=$_DB_NAME"
echo "_DB_USER=$_DB_USER"
echo "_DB_SCHEMA=$_DB_SCHEMA"

# Optional return to original directory
cd "$ORIGINAL_DIR" || exit 1
