#!/bin/bash

set -e

cd "$(dirname "$0")"

for i in tests/*; do
    echo "Running $i..."
    ./docker-run.sh fake "$i"
    diff output/results.json "$i"/expected_results.json
    echo "OK"
done
