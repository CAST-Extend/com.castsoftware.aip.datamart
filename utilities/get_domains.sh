#!/usr/bin/env bash

# set -x
set -e
set -o pipefail

fail() {
    echo "Access is denied to write $2 file into current directory"
    exit 1
}

if ! printf "" > "$2"; then
    fail
fi

# Deactivate temporary pipeline error to get exit code
set +e
python utilities/curl.py application/json "$1" | python utilities/filter_domains.py > "$2"
rc=$?
set -e
exit $rc
