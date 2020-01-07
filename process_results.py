#!/usr/bin/env python3

import argparse
import json
import os
import re


def load_test_names(filename):
    test_names = []
    with open(filename) as f:
        for line in f:
            m = re.search("RUN_TEST\((.*)\)", line)
            if m:
                test_names.append(m.group(1))
    return test_names


def process_results(filename):
    output = {"status": "pass", "message": None, "tests": []}
    case = {}
    done = False
    test_names_loaded = False
    buf = ""
    i = 0
    with open(filename) as f:
        f.readline()
        for line in f:
            data = line.rstrip().split(":")
            if len(data) >= 4 and re.search("test_.*.c", data[0]):
                if not test_names_loaded:
                    test_names = load_test_names(data[0])
                    test_names_loaded = True
                case["name"] = data[2]
                case["status"] = data[3].lower()
                if case["status"] == "fail":
                    output["status"] = "fail"
                    case["message"] = data[4].lstrip()
                if buf:
                    if len(buf) > 500:
                        case["output"] = buf[:500] + "\nOutput was truncated. Please limit to 500 chars."
                    else:
                        case["output"] = buf
                    buf = ""
                output["tests"].append(case)
                if case["name"] == test_names[-1]:
                    done = True
                    break
                case = {}
                i += 1
            else:
                buf += line
    if not done:
        output["status"] = "error"
        output["message"] = buf
    return output


def write_output_file(filename, output):
    with open(filename, "w") as f:
        f.write(json.dumps(output, indent=2) + "\n")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("results_file")
    args = parser.parse_args()
    output = process_results(args.results_file)
    output_file = os.path.splitext(args.results_file)[0] + ".json"
    write_output_file(output_file, output)


if __name__ == "__main__":
    main()
