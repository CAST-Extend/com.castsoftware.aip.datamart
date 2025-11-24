#!/usr/bin/env bash

# set -x
set -e
set -o pipefail

echo Fetch snapshots from $1
set +e
python utilities/curl.py text/csv "$1" | python utilities/check_new_snapshot.py $2
rc=$?
set -e
exit $rc

