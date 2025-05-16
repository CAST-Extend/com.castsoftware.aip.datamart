#!/bin/sh

# ------------------------------------------------------------------------------
# DO NOT CHANGE ANYTHING BELOW THIS LINE
# ------------------------------------------------------------------------------

INSTALLATION_FOLDER="$(pwd)"
PGSQL="pgsql-10.12"

# Add path for embedded third party binaries
[ -d "$INSTALLATION_FOLDER/thirdparty/curl-7.70/bin" ] && export PATH="$INSTALLATION_FOLDER/thirdparty/curl-7.70/bin:$PATH"
[ -d "$INSTALLATION_FOLDER/thirdparty/Python38-32" ] && export PATH="$INSTALLATION_FOLDER/thirdparty/Python38-32:$PATH"

if [ -n "$PGSQL" ] && [ -d "$INSTALLATION_FOLDER/thirdparty/$PGSQL/bin" ]; then
  export PATH="$INSTALLATION_FOLDER/thirdparty/$PGSQL/bin:$PATH"
  export PSQL="psql"
  export VACUUMDB="vacuumdb"
fi

command -v python >/dev/null 2>&1 || { echo "ERROR: Python is not found"; exit 1; }
command -v curl >/dev/null 2>&1 || { echo "ERROR: CURL is not found"; exit 1; }

command -v "${PSQL:-psql}" >/dev/null 2>&1 || { [ -x "$PSQL" ] || { echo "ERROR: PSQL is not found"; exit 1; }; }
command -v "${VACUUMDB:-vacuumdb}" >/dev/null 2>&1 || { [ -x "$VACUUMDB" ] || { echo "ERROR: VACUUMDB is not found"; exit 1; }; }

python utilities/check_python_version.py || exit 1

if [ -n "$APIKEY" ] && [ -z "$APIUSER" ]; then
  echo "ERROR: APIUSER must be set along APIKEY"
  exit 1
fi

# Default extraction scope
: "${EXTRACT_DATAPOND:=OFF}"
case "$EXTRACT_DATAPOND" in ON|OFF) ;; *) echo "ERROR: Invalid EXTRACT_DATAPOND value $EXTRACT_DATAPOND, expecting ON or OFF"; exit 1;; esac

: "${EXTRACT_SRC:=ON}"
case "$EXTRACT_SRC" in ON|OFF) ;; *) echo "ERROR: Invalid EXTRACT_SRC value $EXTRACT_SRC, expecting ON or OFF"; exit 1;; esac

: "${EXTRACT_MOD:=ON}"
case "$EXTRACT_MOD" in ON|OFF) ;; *) echo "ERROR: Invalid EXTRACT_MOD value $EXTRACT_MOD, expecting ON or OFF"; exit 1;; esac

: "${EXTRACT_TECHNO:=ON}"
case "$EXTRACT_TECHNO" in ON|OFF) ;; *) echo "ERROR: Invalid EXTRACT_TECHNO value $EXTRACT_TECHNO, expecting ON or OFF"; exit 1;; esac

: "${EXTRACT_USR:=ON}"
case "$EXTRACT_USR" in ON|OFF) ;; *) echo "ERROR: Invalid EXTRACT_USR value $EXTRACT_USR, expecting ON or OFF"; exit 1;; esac

: "${DEBUG:=OFF}"
case "$DEBUG" in ON|OFF) ;; *) echo "ERROR: Invalid DEBUG value $DEBUG, expecting ON or OFF"; exit 1;; esac

: "${EXTRACT_ZERO_WEIGHT:=OFF}"
case "$EXTRACT_ZERO_WEIGHT" in ON|OFF) ;; *) echo "ERROR: Invalid EXTRACT_ZERO_WEIGHT value $EXTRACT_ZERO_WEIGHT, expecting ON or OFF"; exit 1;; esac

# Required variable checks
[ -z "$DEFAULT_DOMAIN" ] && { echo "ERROR: Missing variable DEFAULT_DOMAIN"; exit 1; }
[ -z "$DEFAULT_ROOT" ] && { echo "ERROR: Missing variable DEFAULT_ROOT"; exit 1; }
[ -z "$_DB_HOST" ] && { echo "ERROR: Missing variable _DB_HOST"; exit 1; }
[ -z "$_DB_PORT" ] && { echo "ERROR: Missing variable _DB_PORT"; exit 1; }
[ -z "$_DB_NAME" ] && { echo "ERROR: Missing variable _DB_NAME"; exit 1; }
[ -z "$_DB_USER" ] && { echo "ERROR: Missing variable _DB_USER"; exit 1; }
[ -z "$_DB_SCHEMA" ] && { echo "ERROR: Missing variable _DB_SCHEMA"; exit 1; }

# Set folders
: "${EXTRACT_FOLDER:=$INSTALLATION_FOLDER/extract}"
: "${TRANSFORM_FOLDER:=$INSTALLATION_FOLDER/transform}"
: "${LOG_FOLDER:=$INSTALLATION_FOLDER/log}"

mkdir -p "$EXTRACT_FOLDER" "$TRANSFORM_FOLDER" "$LOG_FOLDER"

export VIEWS_FOLDER="$INSTALLATION_FOLDER/views"

NOW=$(python utilities/isodatetime.py)
export NOW

: "${JOBS:=1}"

export PSQL_OPTIONS="-d $_DB_NAME -h $_DB_HOST -U $_DB_USER -p $_DB_PORT --set=ON_ERROR_STOP=true"
export VACUUM_OPTIONS="-h $_DB_HOST -U $_DB_USER -p $_DB_PORT"
