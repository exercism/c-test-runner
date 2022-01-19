#!/usr/bin/env sh

# Synopsis:
# Run the test runner on a solution.

# Arguments:
# $1: exercise slug
# $2: absolute path to solution folder
# $3: absolute path to output directory

# Output:
# Writes the test results to a results.json file in the passed-in output directory.
# The test results are formatted according to the specifications at https://github.com/exercism/docs/blob/main/building/tooling/test-runners/interface.md

# Example:
# ./bin/run.sh two-fer /absolute/path/to/two-fer/solution/folder/ /absolute/path/to/output/directory/

# If any required arguments is missing, print the usage and exit
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "usage: ./bin/run.sh exercise-slug /absolute/path/to/two-fer/solution/folder/ /absolute/path/to/output/directory/"
    exit 1
fi

slug="$1"
input_dir="${2%/}"
output_dir="${3%/}"
exercise="${slug//-/_}"
process_results_file="/opt/test-runner/bin/process_results.py"
tests_file="test_${exercise}.c"
tests_file_original="${tests_file}.original"
results_file="${output_dir}/results.json"
output_file="${output_dir}/results.out"

# Create the output directory if it doesn't exist
mkdir -p "${output_dir}"

echo "${slug}: testing..."

cd "${input_dir}" > /dev/null

cp "${tests_file}" "${tests_file_original}"
cp "${makefile}" "${makefile_original}"
sed -i '/TEST_IGNORE\(\)/d' "${tests_file}"

make clean
stdbuf -oL make > "${output_file}" 2>&1
python3 "${process_results_file}" "${output_file}"

# Restore the original file
mv -f "${tests_file_original}" "${tests_file}"

cd - > /dev/null

echo "${slug}: done"
