#!/bin/bash

# RCV. Last updated 4 Dec 2025
# Usage: ./run_pipeline.sh <query_fasta_dir> <prey_fasta_dir>

set -e

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <query_fasta_dir> <prey_fasta_dir>"
    exit 1
fi

query_fasta_dir="$1"
prey_fasta_dir="$2"

# Find exactly one fasta in query dir
query_fasta_count=$(find "$query_fasta_dir" -maxdepth 1 -name "*.fas" | wc -l)
if [ "$query_fasta_count" -ne 1 ]; then
    echo "Error: Query FASTA directory must contain exactly one .fas file (found $query_fasta_count)"
    exit 1
fi

query_fasta_path=$(find "$query_fasta_dir" -maxdepth 1 -name "*.fas")
query_name=$(basename "$query_fasta_path" .fas)

cwd=$(pwd)
workdir="$cwd/$query_name"

echo "Starting pipeline for query '$query_name'..."

echo "Step 1: Combining FASTAs..."
bash ./scripts/combine.sh "$workdir" "$query_fasta_path" "$prey_fasta_dir"

echo "Step 2: Running ColabFold..."
bash ./scripts/batch_run.sh "$workdir"

echo "Step 3: Grabbing ipTM scores..."
bash ./scripts/iptm_parser.sh "$workdir"

echo "Pipeline complete! Results are in $workdir/"
