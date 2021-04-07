#!/bin/bash

set -e

cd "$(dirname "$0")"

docker build -t test-runner .

for $i in tests/*; do
    echo "Running $i..."
    docker run \
        --network none \
        --read-only \
        --rm \
        -v "$(pwd)"/"$i":/mnt/exercism-iteration \
        -v "$(pwd)"/output:/output \
        test-runner "fake" /mnt/exercism-iteration/ /output/
    diff output/results.json "$i"/expected_results.json
    echo "OK"
done
