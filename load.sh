#!/usr/bin/env bash

#set -x
set -e
set -o pipefail

#######################################
# Usage
#######################################
usage() {
    echo "This command should be called from run.sh or datamart.sh"
    echo "Usage:"
    echo
    echo "Single Data Source"
    echo "  load refresh|install"
    echo "  load refresh|install DOMAIN"
    echo "    Load CSV data for install/refresh."
    echo "    If DOMAIN is missing, DEFAULT_DOMAIN is applied."
    echo
    echo "Multiple Data Source"
    echo "  load install|refresh|hd-update HD_ROOT AAD"
    echo "  load ed-install|ed-update ED_ROOT DOMAIN"
    echo
    exit 1
}

#######################################
# Functions
#######################################

install_() {
    echo "Create schema '${_DB_SCHEMA}' if not exists"

    python utilities/run.py "${PSQL}" ${PSQL_OPTIONS} \
        -c "DO \$\$ BEGIN IF NOT EXISTS(SELECT schema_name FROM information_schema.schemata WHERE schema_name = lower('${_DB_SCHEMA}')) THEN CREATE SCHEMA ${_DB_SCHEMA}; END IF; END \$\$;" \
        >> "$LOG_FILE" 2>&1 || return 1

    load DIM_APPLICATIONS || return 1
    load DATAPOND_ORGANIZATION || return 1

    echo "Create other tables"
    python utilities/run.py "${PSQL}" ${PSQL_OPTIONS} \
        --set=schema="${_DB_SCHEMA}" -f create_tables.sql \
        >> "$LOG_FILE" 2>&1 || return 1

    sh ./load_data_dictionary.sh || return 1

    load_other_measures || return 1
    load_details || return 1
}

refresh() {
    load_measures || return 1
    load_details || return 1
}

load_measures() {
    load DIM_APPLICATIONS || return 1
    load_other_measures || return 1
}

load_other_measures() {
    load DIM_SNAPSHOTS || return 1
    load DIM_RULES || return 1
    load DIM_OMG_RULES || return 1
    load DIM_CISQ_RULES || return 1
    load APP_VIOLATIONS_MEASURES || return 1
    load APP_VIOLATIONS_EVOLUTION || return 1
    load APP_SIZING_MEASURES || return 1
    load APP_TECHNO_SIZING_MEASURES || return 1
    load APP_FUNCTIONAL_SIZING_MEASURES || return 1
    load APP_HEALTH_SCORES || return 1
    load APP_SCORES || return 1
    load APP_TECHNO_SCORES || return 1
    load APP_SIZING_EVOLUTION || return 1
    load APP_TECHNO_SIZING_EVOLUTION || return 1
    load APP_FUNCTIONAL_SIZING_EVOLUTION || return 1
    load APP_HEALTH_EVOLUTION || return 1
    load MOD_VIOLATIONS_MEASURES || return 1
    load MOD_VIOLATIONS_EVOLUTION || return 1
    load MOD_SIZING_MEASURES || return 1
    load MOD_TECHNO_SIZING_MEASURES || return 1
    load MOD_HEALTH_SCORES || return 1
    load MOD_SCORES || return 1
    load MOD_TECHNO_SCORES || return 1
    load MOD_SIZING_EVOLUTION || return 1
    load MOD_TECHNO_SIZING_EVOLUTION || return 1
    load MOD_HEALTH_EVOLUTION || return 1
    load STD_RULES || return 1
    load STD_DESCRIPTIONS || return 1
    load_view DIM_QUALITY_STANDARDS || return 1
}

load_details() {
    load SRC_OBJECTS || return 1
    load SRC_TRANSACTIONS || return 1
    load SRC_MOD_OBJECTS || return 1
    load SRC_TRX_OBJECTS || return 1
    load SRC_VIOLATIONS || return 1
    load SRC_HEALTH_IMPACTS || return 1
    load SRC_TRX_HEALTH_IMPACTS || return 1
    load USR_EXCLUSIONS || return 1
    load USR_ACTION_PLAN || return 1
    load APP_FINDINGS_MEASURES || return 1
}

#######################################
# FAIL
#######################################
fail() {
    echo "== Load Failed (see $LOG_FILE) =="
    exit 1
}

#######################################
# SUCCESS
#######################################
success() {
    if [ "$DEBUG" = "OFF" ]; then
        echo "Cleanup '${DOMAIN}' intermediate files"
        rm -rf "${EXTRACT_FOLDER}/${DOMAIN}"
        rm -rf "${TRANSFORM_FOLDER}/${DOMAIN}"
    fi

    echo "== Load Done: schema '${_DB_SCHEMA}', database '${_DB_NAME}', host '${_DB_HOST}' =="
    exit 0
}

#######################################
# LOAD
#######################################
load() {
    local sql="${TRANSFORM_FOLDER}/${DOMAIN}/$1.sql"

    if [ ! -f "$sql" ]; then
        return 0
    fi

    echo "Load $sql"
    python utilities/run.py "${PSQL}" ${PSQL_OPTIONS} \
        --set=schema="${_DB_SCHEMA}" -f "$sql" \
        >> "$LOG_FILE" 2>&1 || return 1

    python utilities/run.py "${VACUUMDB}" -z ${VACUUM_OPTIONS} \
        -t "${_DB_SCHEMA}.$1" "${_DB_NAME}" \
        >> "$LOG_FILE" 2>&1 || return 1
}

#######################################
# LOAD VIEW
#######################################
load_view() {
    local sql="${VIEWS_FOLDER}/$1.sql"
    echo "Load $sql"

    python utilities/run.py "${PSQL}" ${PSQL_OPTIONS} \
        --set=schema="${_DB_SCHEMA}" -f "$sql" \
        >> "$LOG_FILE" 2>&1 || return 1
}

. ./checkenv.sh || fail

DOMAIN="$2"
if [ -z "$DOMAIN" ]; then
    DOMAIN="$DEFAULT_DOMAIN"
fi

LOG_FILE="${LOG_FOLDER}/${DOMAIN}.log"
: > "$LOG_FILE"

#######################################
# Dispatcher
#######################################
case "$1" in
    install)
        install_ && success
        ;;
    refresh)
        refresh && success
        ;;
    ed-install)
        load_details && success
        ;;
    ed-update)
        load_details && success
        ;;
    hd-update) 
        load_measures && success
        ;;
esac
