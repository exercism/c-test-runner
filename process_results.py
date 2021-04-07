#!/usr/bin/env python3

import argparse
import json
from pathlib import Path
import re


rgx_testnames = re.compile(r"RUN_TEST\(([^)]+)\);")
last_test_name = {}


def get_last_test_name(filepath):
    if filepath not in last_test_name:
        last_test_name[filepath] = rgx_testnames.findall(
            Path(filepath).read_text())[-1]
    return last_test_name[filepath]


def truncate(text, maxlength=500):
    if len(text) > maxlength:
        text = f"{text[:maxlength]}\nOutput was truncated. Please limit to {maxlength} chars."
    return text


def process_results(filepath):
    output = {"version": 2, "status": "pass", "message": None, "tests": []}
    pattern = r"(?m)^((?P<file>.*test_.*\.c):\d+:(?P<name>\w+):(?P<status>PASS|FAIL)(?:: (?P<message>.*))?)$"
    text = filepath.read_text()
    text = text[20:]
    for match in re.finditer(pattern, text):
        full_line, source_file, name, status, message = match.groups()
        case = {"name": name, "status": status.lower()}
        if status == "FAIL":
            output["status"] = "fail"
        if message:
            case["message"] = message
        output_text, _, text = text.partition(f"{full_line}\n")
        if output_text:
            case["output"] = truncate(output_text)
        output["tests"].append(case)
        if name == get_last_test_name(source_file):
            break
    else:
        output["status"] = "error"
        output["message"] = text
    return output


def write_output_file(filename, output):
    with filename.open("w") as f:
        json.dump(output, f, indent=2)
        f.write("\n")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("results_file", type=Path)
    args = parser.parse_args()
    output = process_results(args.results_file)
    output_file = args.results_file.with_suffix(".json")
    write_output_file(output_file, output)


if __name__ == "__main__":
    main()
