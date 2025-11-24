#!/usr/bin/env bash

# set -x
set -e
set -o pipefail

# Store the start time in milliseconds (requires GNU date)
start_time=$(date +%s%3N)

# Run the command passed as arguments
"$@"
exit_code=$?

# Store the end time in milliseconds
end_time=$(date +%s%3N)

# Calculate the elapsed time in milliseconds
elapsed_ms=$((end_time - start_time))

# Break down elapsed time into hours, minutes, seconds, milliseconds
elapsed_s=$((elapsed_ms / 1000))
ms=$((elapsed_ms % 1000))
h=$((elapsed_s / 3600))
m=$(((elapsed_s % 3600) / 60))
s=$((elapsed_s % 60))

# Print formatted result
printf "Time elapsed: %02d:%02d:%02d.%03d (%d.%03ds total)\n" "$h" "$m" "$s" "$ms" "$elapsed_s" "$ms"

# Return the exit code of the command that was run
exit $exit_code
