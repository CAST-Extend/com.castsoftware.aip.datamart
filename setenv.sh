#!/bin/sh

# ------------------------------------------------------------------------------
# CONFIGURE THE FOLLOWING SETTINGS
# ------------------------------------------------------------------------------

# -----
# REST API
# -----

# Set REST API credentials or API key and user
export CREDENTIALS=""
# export APIUSER=""
# export APIKEY=""

# In case of a single domain extraction (run.sh)
# Do NOT include a trailing slash
export DEFAULT_ROOT="http://localhost:9090/rest"
export DEFAULT_DOMAIN="AAD"

# In case of a multiple domains extraction (datamart.sh),
# Set HD (Health Dashboard) and ED (Engineering Dashboard) URLs
# Up to 10 ED domains (ED_ROOT_0 to ED_ROOT_9)
# Do NOT include a trailing slash
export HD_ROOT="http://localhost:8080/rest"
export ED_ROOT_0="http://localhost:8080/rest"
export ED_ROOT_1=""
# export ED_ROOT_2=""
# ...
# export ED_ROOT_9=""

# Number of concurrent processes
export JOBS=1

# -----
# EXTRACTION SCOPE
# -----

# For Datapond-compliant extraction, you may enable the following
# export EXTRACT_DATAPOND="ON"
# export EXTRACT_MOD="OFF"
# export EXTRACT_TECHNO="OFF"
# export EXTRACT_SRC="OFF"
# export EXTRACT_USR="ON"

# Limit the snapshot interval in months
# export EXTRACT_SNAPSHOTS_MONTHS=6

# -----
# TARGET DATABASE
# -----

export _DB_HOST="localhost"
export _DB_PORT="2282"
export _DB_NAME="reporting"
export _DB_USER=""
export _DB_SCHEMA="datamart"
export PGPASSWORD=""
