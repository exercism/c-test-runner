#!/bin/bash

set -e

cd "$(dirname "$0")"

docker build -t test-runner .

for testname in tests/*; do
    echo "Running ${testname}..."
    docker run \
        --network none \
        --read-only \
        --rm \
        -v "$(pwd)"/"${testname}":/mnt/exercism-iteration \
        -v "$(pwd)"/output:/output \
        test-runner "fake" /mnt/exercism-iteration/ /output/
    diff output/results.json "${testname}"/expected_results.json
    echo "OK"
done
