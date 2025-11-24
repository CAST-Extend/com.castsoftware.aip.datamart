#!/usr/bin/env bash

# set -x
set -e
set -o pipefail

fail() {
    echo "Access is denied to write $1 file into current directory"
    exit 1
}

fail2() {
    echo "Cannot fetch snapshots from Datamart"
    exit 1
}

if ! printf "" > "$1"; then
    fail
fi

python utilities/get_snapshots.py "$1" || fail2
exit 0
