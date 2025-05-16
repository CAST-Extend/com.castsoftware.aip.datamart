#!/bin/sh

# == Load environment ==
. ./setenv.sh || fail
. ./checkenv.sh || fail

MODE="$1"
ROOT="$2"
DOMAIN="$3"

# == If 2nd arg is empty and 3rd is not => show usage ==
if [ -z "$ROOT" ] && [ -n "$DOMAIN" ]; then
  usage
fi

# == Use default values if unset ==
[ -z "$ROOT" ] && ROOT="$DEFAULT_ROOT"
[ -z "$DOMAIN" ] && DOMAIN="$DEFAULT_DOMAIN"

# == Ensure extract folder exists ==
mkdir -p "$EXTRACT_FOLDER/$DOMAIN"

# == Clear previous extract if DEBUG is OFF ==
[ "$DEBUG" = "OFF" ] && rm -f "$EXTRACT_FOLDER/$DOMAIN"/*

# == Dispatch ==
case "$MODE" in
  refresh|install)
    extract_all && success
    ;;
  ed-install|ed-update)
    extract_details && success
    ;;
  hd-update)
    extract_measures && success
    ;;
  *)
    usage
    ;;
esac

# === Functions ===

usage() {
  echo "This command should be called from the run.sh or datamart.sh command"
  echo "Usage is"
  echo
  echo "Single Data Source:"
  echo "  extract.sh refresh|install"
  echo "  extract.sh refresh|install ROOT DOMAIN"
  echo "    → Full extraction (default domain/root if missing)"
  echo
  echo "Multiple Data Source:"
  echo "  extract.sh install HD_ROOT AAD"
  echo "  extract.sh refresh HD_ROOT AAD"
  echo "  extract.sh ed-install|ed-update ED_ROOT ED_DOMAIN"
  echo "  extract.sh hd-update HD_ROOT AAD"
  fail
}

extract_all() {
  extract_measures || return 1
  extract_details || return 1
}

extract_measures() {
  extract "datamart/dim-snapshots" DIM_SNAPSHOTS
  extract "datamart/dim-rules" DIM_RULES
  extract "datamart/dim-omg-rules" DIM_OMG_RULES
  extract "datamart/dim-cisq-rules" DIM_CISQ_RULES
  extract "datamart/dim-applications" DIM_APPLICATIONS
  extract "datamart/app-violations-measures" APP_VIOLATIONS_MEASURES
  extract "datamart/app-violations-evolution" APP_VIOLATIONS_EVOLUTION
  extract "datamart/app-sizing-measures" APP_SIZING_MEASURES
  extract "datamart/app-functional-sizing-measures" APP_FUNCTIONAL_SIZING_MEASURES
  extract "datamart/app-health-scores" APP_HEALTH_SCORES
  extract "datamart/app-scores" APP_SCORES
  extract "datamart/app-sizing-evolution" APP_SIZING_EVOLUTION
  extract "datamart/app-functional-sizing-evolution" APP_FUNCTIONAL_SIZING_EVOLUTION
  extract "datamart/app-health-evolution" APP_HEALTH_EVOLUTION
  extract "datamart/std-rules" STD_RULES
  extract "datamart/std-descriptions" STD_DESCRIPTIONS

  [ "$EXTRACT_TECHNO" = "ON" ] && extract_app_techno
  [ "$EXTRACT_MOD" = "ON" ] && extract_mod
}

extract_app_techno() {
  extract "datamart/app-techno-sizing-measures" APP_TECHNO_SIZING_MEASURES
  extract "datamart/app-techno-scores" APP_TECHNO_SCORES
  extract "datamart/app-techno-sizing-evolution" APP_TECHNO_SIZING_EVOLUTION
}

extract_mod() {
  extract "datamart/mod-violations-measures" MOD_VIOLATIONS_MEASURES
  extract "datamart/mod-violations-evolution" MOD_VIOLATIONS_EVOLUTION
  extract "datamart/mod-sizing-measures" MOD_SIZING_MEASURES
  extract "datamart/mod-health-scores" MOD_HEALTH_SCORES
  extract "datamart/mod-scores" MOD_SCORES
  extract "datamart/mod-sizing-evolution" MOD_SIZING_EVOLUTION
  extract "datamart/mod-health-evolution" MOD_HEALTH_EVOLUTION

  [ "$EXTRACT_TECHNO" = "ON" ] && extract_mod_techno
}

extract_mod_techno() {
  extract "datamart/mod-techno-sizing-measures" MOD_TECHNO_SIZING_MEASURES
  extract "datamart/mod-techno-scores" MOD_TECHNO_SCORES
  extract "datamart/mod-techno-sizing-evolution" MOD_TECHNO_SIZING_EVOLUTION
}

extract_details() {
  extract "datamart/app-findings-measures" APP_FINDINGS_MEASURES
  [ "$EXTRACT_USR" = "ON" ] && extract_usr
  [ "$EXTRACT_SRC" = "ON" ] && extract_src
}

extract_usr() {
  extract "datamart/usr-exclusions" USR_EXCLUSIONS
  extract "datamart/usr-action-plan" USR_ACTION_PLAN
}

extract_src() {
  extract "datamart/src-objects" SRC_OBJECTS
  extract "datamart/src-transactions" SRC_TRANSACTIONS
  extract "datamart/src-trx-objects" SRC_TRX_OBJECTS
  extract "datamart/src-health-impacts" SRC_HEALTH_IMPACTS
  extract "datamart/src-trx-health-impacts" SRC_TRX_HEALTH_IMPACTS
  extract "datamart/src-violations" SRC_VIOLATIONS

  [ "$EXTRACT_MOD" = "ON" ] && extract_src_mod
}

extract_src_mod() {
  extract "datamart/src-mod-objects" SRC_MOD_OBJECTS
}

extract() {
  SOURCE="$1"
  FILENAME="$2"
  echo
  echo "------------------------------"
  echo "Extract $EXTRACT_FOLDER/$DOMAIN/$FILENAME.csv"
  echo "------------------------------"
  EXTRACT_URL="$ROOT/$DOMAIN/$SOURCE?a=1"

  [ -n "$EXTRACT_SNAPSHOTS_MONTHS" ] && EXTRACT_URL="$EXTRACT_URL&snapshots-months=$EXTRACT_SNAPSHOTS_MONTHS"
  [ "$EXTRACT_ZERO_WEIGHT" = "ON" ] && EXTRACT_URL="$EXTRACT_URL&extract-zero-weight=on"

  python utilities/curl.py text/csv "$EXTRACT_URL" -o "$EXTRACT_FOLDER/$DOMAIN/$FILENAME.csv" || return 1
}

fail() {
  echo "== Extract Failed =="
  rm -f cookies.txt
  exit 1
}

success() {
  echo "== Extract Done =="
  rm -f cookies.txt
  exit 0
}
