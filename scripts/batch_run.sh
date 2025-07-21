#!/bin/bash

# RCV. Last updated 21 July 2025
# Usage: ./batch_run.sh <workdir>

set -e

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <workdir>"
    exit 1
fi

workdir="$1"
csv_dir="$workdir/csv"

if [ ! -d "$csv_dir" ]; then
    echo "Error: CSV directory not found: $csv_dir"
    exit 1
fi

# Adjust paramaters as needed, see colabfold_batch --help
for csv_file in "$csv_dir"/*.csv; do
    echo "Running ColabFold on $csv_file ..."
    colabfold_batch \
        --templates \
        --num-models 3 \
        --num-recycle 5 \
        --recycle-early-stop-tolerance 0.5 \
        --use-gpu-relax \
        --model-type alphafold2_multimer_v3 \
        "$csv_file" \
        "$workdir"
done

echo "batch_run.sh completed successfully for $workdir."
