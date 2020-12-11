#!/bin/bash
set -eu

# Run extra queries
/opt/hostedtoolcache/CodeQL/0.0.0-20201106/x64/codeql/codeql database run-queries /home/runner/work/_temp/codeql_databases/javascript \
                ./hackathon/LinesOfCode.ql \
                ./hackathon/LinesOfComment.ql \
                ./chackathon/RemoteFlowSources.ql \
                
# Convert to csv
/opt/hostedtoolcache/CodeQL/0.0.0-20201106/x64/codeql/codeql bqrs decode --format=csv scratch/database/results/hackathon/LinesOfCode.bqrs > hackathon/LinesOfCode.csv
/opt/hostedtoolcache/CodeQL/0.0.0-20201106/x64/codeql/codeql bqrs decode --format=csv scratch/database/results/hackathon/LinesOfComment.bqrs > hackathon/LinesOfComment.csv
/opt/hostedtoolcache/CodeQL/0.0.0-20201106/x64/codeql/codeql bqrs decode --format=csv scratch/database/results/hackathon/RemoteFlowSources.bqrs > hackathon/RemoteFlowSources.csv

# Merge results into sarif
./hackathon/script.py --sarif /home/runner/work/juice-shop/results/javascript-builtin.sarif --output /home/runner/work/juice-shop/results/javascript-builtin.sarif

