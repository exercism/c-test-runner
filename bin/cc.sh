#!/usr/bin/env sh

# Synopsis:
# Compiler launcher for the exercise's makefile. run.sh calls `make CC=<this script>`.

# Every exercise's makefile compiles Unity's test-framework/unity.c along with the
# solution and the tests, which takes most of the compile time of a run.
# The image holds unity.c already compiled with the CFLAGS of the track's makefiles
# (see bin/prebuild-unity.sh). If the solution's unity.c is the same as the image's
# copy and an object exists for the same flags, this script links that object in place
# of compiling unity.c again. Otherwise it runs the compiler unchanged.

unity_dir=/opt/test-runner/unity

# The object's name comes from the flags that affect how unity.c compiles,
# which are all the options apart from the output file and the libraries.
flags_key() {
    flags=""
    while [ $# -gt 0 ]; do
        case "$1" in
            -o) shift ;;
            -l*) ;;
            -*) flags="${flags} $1" ;;
        esac
        shift
    done
    echo "${flags}" | md5sum | cut -d ' ' -f 1
}

object="${unity_dir}/$(flags_key "$@").o"

if [ -f "${object}" ] \
    && cmp -s test-framework/unity.c "${unity_dir}/unity.c" \
    && cmp -s test-framework/unity.h "${unity_dir}/unity.h" \
    && cmp -s test-framework/unity_internals.h "${unity_dir}/unity_internals.h"; then
    for arg; do
        shift
        [ "${arg}" = "test-framework/unity.c" ] && arg="${object}"
        set -- "$@" "${arg}"
    done
fi

exec gcc "$@"
