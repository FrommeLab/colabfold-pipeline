#!/bin/bash

# RCV. Last updated 21 July 2025
# Usage: ./combine.sh <workdir> <query_fasta_path> <prey_fasta_dir>

set -e

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <workdir> <query_fasta_path> <prey_fasta_dir>"
    exit 1
fi

workdir="$1"
query_fasta_path="$2"
prey_fasta_dir="$3"

csv_dir="$workdir/csv"
query_name=$(basename "$query_fasta_path" .fas)

if [ ! -f "$query_fasta_path" ]; then
    echo "Error: Query FASTA file not found: $query_fasta_path"
    exit 1
fi

if [ ! -d "$prey_fasta_dir" ]; then
    echo "Error: Prey FASTA directory not found: $prey_fasta_dir"
    exit 1
fi

mkdir -p "$csv_dir"
tmpfile="$(mktemp)"

for prey_fasta in "$prey_fasta_dir"/*.fas; do
    prey_name=$(basename "$prey_fasta" .fas)
    output_csv="${query_name}_${prey_name}.csv"

    echo -n "${query_name}_${prey_name}," > "$tmpfile"
    cat "$query_fasta_path" | tr -d '\n' | tr -d '*' >> "$tmpfile"
    echo -n ":" >> "$tmpfile"
    cat "$prey_fasta" | tr -d '\n' | tr -d '*' >> "$tmpfile"

    {
     	echo "id,sequence"
        cat "$tmpfile"
    } > "$csv_dir/$output_csv"
done

rm -f "$tmpfile"
echo "combine.sh complete: CSV files written to $csv_dir"
