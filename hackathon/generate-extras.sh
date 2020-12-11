#!/bin/bash
set -eu

# Find database log location
find / | grep log

# Run extra queries
/opt/hostedtoolcache/CodeQL/0.0.0-20201106/x64/codeql/codeql database run-queries /home/runner/work/_temp/codeql_databases/javascript \
                ./hackathon/LinesOfCode.ql \
                ./hackathon/LinesOfComment.ql \
                ./hackathon/RemoteFlowSources.ql \
                --library-path-dependency=codeql-javascript


# Convert to csv
/opt/hostedtoolcache/CodeQL/0.0.0-20201106/x64/codeql/codeql bqrs decode --format=csv /home/runner/work/_temp/codeql_databases/javascript/results/hackathon/LinesOfCode.bqrs > hackathon/LinesOfCode.csv
/opt/hostedtoolcache/CodeQL/0.0.0-20201106/x64/codeql/codeql bqrs decode --format=csv /home/runner/work/_temp/codeql_databases/javascript/results/hackathon/LinesOfComment.bqrs > hackathon/LinesOfComment.csv
/opt/hostedtoolcache/CodeQL/0.0.0-20201106/x64/codeql/codeql bqrs decode --format=csv /home/runner/work/_temp/codeql_databases/javascript/results/hackathon/RemoteFlowSources.bqrs > hackathon/RemoteFlowSources.csv

# Merge results into sarif
./hackathon/script.py --sarif /home/runner/work/juice-shop/results/javascript-builtin.sarif --output /home/runner/work/juice-shop/results/javascript-builtin.sarif

