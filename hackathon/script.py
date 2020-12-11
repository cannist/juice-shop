#!/usr/bin/env python3

import argparse
import csv
import glob
import json
import os
import sys

def merge_results(csv_path, name, summarize, sarif):
    with open(csv_path, newline='') as csvfile:
        reader = csv.reader(csvfile)
        # Skip header row
        column_names = next(reader)
        rows = list(reader)
        summary = summarize(rows)
        details = []
        for row in rows:
            detail = {}
            for i, column_name in enumerate(column_names):
                value = row[i]
                detail[column_name] = value
            details.append(detail)
    if 'hackathon' not in sarif['runs'][0]['properties']:
        sarif['runs'][0]['properties']['hackathon'] = []
    sarif['runs'][0]['properties']['hackathon'].append({
        'name': name,
        'summary': summarize(rows),
        'details': details
    })

def merge_log(log_glob, name, sarif):
    files = glob.glob(log_glob)
    if len(files) != 1:
        sys.exit(1)

    with open(files[0], 'r') as f:
        details = f.read()

        if 'hackathon' not in sarif['runs'][0]['properties']:
            sarif['runs'][0]['properties']['hackathon'] = []
        sarif['runs'][0]['properties']['hackathon'].append({
            'name': name,
            'summary': 'length ' + str(len(details)) + ' characters',
            'details': details
        })

def read_sarif(path):
    with open(path, 'r', encoding='utf8') as f:
        return json.load(f)

def write_sarif(data, path):
    with open(path, 'w', encoding='utf8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

def summarize_lines_of_code(rows):
    total = 0
    for row in rows:
        total += int(row[1])
    return str(total)

def summarize_locations(rows):
    return str(len(rows)) + ' locations'

def main(args):
    print("Reading sarif")
    sarif = read_sarif(args.sarif)
    print("Merging Lines of Code results")
    merge_results('hackathon/LinesOfCode.csv', 'Lines of code', summarize_lines_of_code, sarif)
    print("Merging Lines of comment results")
    merge_results('hackathon/LinesOfComment.csv', 'Lines of comment', summarize_lines_of_code, sarif)
    print("Merging database creation log")
    merge_log('/home/runner/work/_temp/codeql_databases/javascript/log/database-finalize-*', 'Database creation log', sarif)
    print("Merging remote flow sources")
    merge_results('hackathon/RemoteFlowSources.csv', 'Remote flow sources', summarize_locations, sarif)
    print("Writing sarif")
    write_sarif(sarif, args.output)
    print("Done")
    return 0

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-s', '--sarif', help='input SARIF file', required=True)
    parser.add_argument('-o', '--output', help='output SARIF file', required=True)
    args = parser.parse_args()

    script_path = os.path.dirname(os.path.realpath(__file__))

    sys.exit(main(args))

