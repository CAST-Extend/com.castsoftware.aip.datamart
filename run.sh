#!/usr/bin/env bash

# set -x
set -e
set -o pipefail


# Simulate pushd/popd behavior
pushd() {
  OLD_DIR="$(pwd)"
  cd "$1" || return 1
}

popd() {
  [ -n "$OLD_DIR" ] && cd "$OLD_DIR" || return 1
}

run() {
  ./extract.sh "$1" "$2" "$3" || fail
  ./transform.sh "$1" "$3" || fail
  ./load.sh "$1" "$3" || fail
}

fail() {
  popd
  echo "== Failed =="
  exit 1
}

usage() {
  echo "Usage is"
  echo "run refresh"
  echo "   to refresh all datamart tables using this domain"
  echo "run install"
  echo "   to create or re-create all the datamart tables; some dependent tables or views will be dropped"
  echo "   use install:"
  echo "      1. for the first run"
  echo "      2. if you have changed the set of quality standard tags"
  echo "      3. to take into account a new version of the datamart Web Services"
  exit 1
}

main() {
  case "$1" in
    refresh|install|ed-install|hd-update|ed-update)
      SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
      pushd "$SCRIPT_DIR" || exit 1
      run "$@"
      popd
      ;;
    *)
      usage
      ;;
  esac
}

main "$@"
