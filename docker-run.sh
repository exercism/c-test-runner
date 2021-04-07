#!/bin/bash

# $1 - The slug of the exercise (e.g. two-fer).
# $2 - A relative path to an input directory containing the submitted solution file(s) and the necessary test file(s).

docker build -t exercism/c-test-runner .
docker run  \
    --network none \
    --read-only \
    --rm \
    --rm \
    -v "$(pwd)"/"$2":/mnt/exercism-iteration \
    -v "$(pwd)"/output:/output \
    exercism/c-test-runner "$1" /mnt/exercism-iteration/ /output/
