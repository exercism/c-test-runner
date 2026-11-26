#!/usr/bin/env sh

# Synopsis:
# Compile Unity's unity.c once for each set of CFLAGS used by the track's makefiles.
# Run at image build. bin/cc.sh links these objects instead of compiling unity.c on every run.

set -e

unity_dir=/opt/test-runner/unity
cd "${unity_dir}"

# These are the CFLAGS in the makefiles of exercism/c's exercises.
# complex-numbers adds -DUNITY_INCLUDE_DOUBLE.
common="-std=c99 -g -Wall -Wextra -pedantic -Werror -Wmissing-declarations -DUNITY_SUPPORT_64"

for flags in \
    "${common} -DUNITY_OUTPUT_COLOR" \
    "${common} -DUNITY_INCLUDE_DOUBLE -DUNITY_OUTPUT_COLOR"; do
    # The same key as bin/cc.sh gives a compile of tests.out with these flags.
    key=$(echo " ${flags}" | md5sum | cut -d ' ' -f 1)
    # Compile from a test-framework folder, like the makefiles do, so the debug info matches.
    mkdir -p build/test-framework
    cp unity.c unity.h unity_internals.h build/test-framework/
    (cd build && gcc ${flags} -c test-framework/unity.c -o "${unity_dir}/${key}.o")
done

rm -rf build
