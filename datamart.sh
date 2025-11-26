#!/usr/bin/env bash

# set -x
set -e
set -o pipefail

# === Functions ===

for_each_ed_domain() {
  MODE="$1"
  SNAPSHOT_FILE="${2:-}"

  for i in $(seq 0 9); do
    eval "ED_ROOT_VAL=\${ED_ROOT_$i:-}"
    if [ -n "$ED_ROOT_VAL" ]; then
      export EXTRACT_FOLDER="$EXTRACT_FOLDER/$i"
      export TRANSFORM_FOLDER="$TRANSFORM_FOLDER/$i"
      export LOG_FOLDER="$LOG_FOLDER/$i"
      ed_datamart "$MODE" "$ED_ROOT_VAL" "DOMAINS_$i.TXT" "$SNAPSHOT_FILE" || return 1
    fi
  done
}

hd_datamart() {
  python datamart.py "$1" "$2"
}

ed_datamart() {
  MODE="$1"
  ROOT="$2"
  DOMAIN_FILE="$3"
  SNAPSHOT_FILE="${4:-}"

  fetch_domains "$ROOT" "$DOMAIN_FILE" || return 1
  python datamart.py "$MODE" "$ROOT" "$DOMAIN_FILE" "$JOBS" "$SNAPSHOT_FILE"
}

fetch_domains() {
  echo
  echo "Fetch domains from $1"
  ./utilities/get_domains.sh "$1" "$2"
  echo
}

fetch_snapshots() {
  ./utilities/get_snapshots.sh "$1"
  echo
}

fail() {
  echo "Datamart $1 FAIL"
  exit 1
}

success() {
  echo "Datamart $1 SUCCESS"
  exit 0
}

# Load environment
. ./checkenv.sh || fail

MODE="$1"

case "$MODE" in
  install)
    hd_datamart "HD-INSTALL" "$HD_ROOT" || fail
    for_each_ed_domain "ED-INSTALL" || fail
    success "$MODE"
    ;;
  refresh)
    hd_datamart "HD-REFRESH" "$HD_ROOT" || fail
    for_each_ed_domain "ED-INSTALL" || fail
    success "$MODE"
    ;;
  update)
    : > "$LOG_FOLDER/datamart_update.stdout"
    fetch_snapshots "DATAMART_SNAPSHOTS.CSV" || fail

    if ./utilities/check_new_snapshot.sh "$HD_ROOT/AAD/datamart/dim-snapshots" DATAMART_SNAPSHOTS.CSV; then
      echo "Datamart is already synchronized. No new snapshot for domain AAD"
      success "$MODE"
    fi

    hd_datamart "HD-UPDATE" "$HD_ROOT" || fail
    for_each_ed_domain "ED-UPDATE" "DATAMART_SNAPSHOTS.CSV" || fail
    success "$MODE"
    ;;
  *)
    echo "Usage:"
    echo "  datamart.sh install      # Create tables and extract from AAD & all ED domains"
    echo "  datamart.sh refresh      # Truncate tables and extract from AAD & all ED domains"
    echo "  datamart.sh update       # Update tables for new snapshot/applications"
    fail "$MODE"
    ;;
esac

