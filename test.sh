#!/bin/bash

set -e

cd "$(dirname "$0")"

for i in tests/*; do
    echo "Running $i..."
    ./docker-run.sh fake "$i"
    if ! diff output/results.json "$i"/expected_results.json; then
        exit 1
    fi
    echo "OK"
done
