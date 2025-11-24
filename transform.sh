#!/usr/bin/env bash

# set -x
set -e
set -o pipefail


# === Functions ===

usage() {
  echo "This command should be called from the run.sh or datamart.sh command"
  echo "Usage is"
  echo
  echo "Single Data Source:"
  echo "  transform.sh install ROOT DOMAIN"
  echo "      Add COPY statement to CSV content"
  echo "  transform.sh refresh ROOT DOMAIN"
  echo "      Add TRUNCATE AND COPY Statements to CSV content"
  echo
  echo "Multiple Data Source:"
  echo "  transform.sh install HD_ROOT AAD"
  echo "      Add COPY statement to CSV content"
  echo "  transform.sh ed-install ED_ROOT DOMAIN"
  echo "      Add COPY statement to CSV content"
  echo "  transform.sh refresh|hd-update HD_ROOT AAD"
  echo "      Add TRUNCATE AND COPY Statements to CSV content"
  echo "  transform.sh ed-update ED_ROOT ED_DOMAIN"
  echo "      Add DELETE and COPY statement to CSV content"
  fail
}

transform() {
  python transform.py \
    --domain "$DOMAIN" \
    --mode "$MODE" \
    --extract "$EXTRACT_FOLDER/$DOMAIN" \
    --transform "$TRANSFORM_FOLDER/$DOMAIN" \
    || fail
  success
}

fail() {
  echo
  echo "== Transform Failed =="
  exit 1
}

success() {
  echo "== Transform Done =="
  exit 0
}


# === Load environment ===
. ./checkenv.sh || fail

# === Get arguments ===
MODE="$1"
DOMAIN="$2"

# Use default domain if not provided
if [ -z "$DOMAIN" ]; then
  DOMAIN="$DEFAULT_DOMAIN"
fi

# === Create transform folder if it doesn't exist ===
if [ ! -d "$TRANSFORM_FOLDER/$DOMAIN" ]; then
  mkdir -p "$TRANSFORM_FOLDER/$DOMAIN"
fi

# Delete files if DEBUG is OFF
if [ "$DEBUG" = "OFF" ]; then
  rm -f "$TRANSFORM_FOLDER/$DOMAIN"/*
fi

# === Dispatch based on mode ===
case "$MODE" in
  install|refresh|ed-install|hd-update|ed-update)
    transform
    ;;
  *)
    usage
    ;;
esac