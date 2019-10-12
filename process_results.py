#!/usr/bin/env python3

import argparse
import json
import os


def read_test_names(filename):
    with open(filename) as f:
        test_names = f.read().splitlines()
    return test_names


def process_results(filename, test_names):
    output = {"status": "pass", "tests": []}
    with open(filename) as f:
        f.readline()
        for i, line in enumerate(f):
            if i >= len(test_names):
                break
            case = {"name": test_names[i], "status": "fail"}
            data = line.rstrip().split(":")
            if len(data) >= 4 and data[2] == test_names[i]:
                case["status"] = data[3].lower()
                if case["status"] == "fail":
                    output["status"] = "fail"
                    case["message"] = data[4].lstrip()
                output["tests"].append(case)
            else:
                output["status"] = "fail"
                output["message"] = line + f.read()
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
