#!/usr/bin/env python3

import argparse
import json
import os


def read_test_names(filename):
    with open(filename) as f:
        test_names = f.read().splitlines()
    return test_names


def process_results(filename, test_names):
    output = {"status": "pass", "message": None, "tests": []}
    case = {}
    done = False
    buf = ""
    i = 0
    with open(filename) as f:
        f.readline()
        for line in f:
            data = line.rstrip().split(":")
            if len(data) >= 4 and data[2] == test_names[i]:
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
    parser.add_argument("test_names_file")
    parser.add_argument("results_file")
    args = parser.parse_args()
    test_names = read_test_names(args.test_names_file)
    output = process_results(args.results_file, test_names)
    output_file = os.path.splitext(args.results_file)[0] + ".json"
    write_output_file(output_file, output)


if __name__ == "__main__":
    main()
