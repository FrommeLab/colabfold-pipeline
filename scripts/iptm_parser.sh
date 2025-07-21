#!/bin/bash

# RCV. Last updated 21 July 2025
# Usage: ./iptm_parser.sh <path_to_gene_directory>

set -euo pipefail

gene_dir="$1"
gene_name=$(basename "$gene_dir")
iptm_dir="$gene_dir/iptm"

mkdir -p "$iptm_dir"

iptm_file="$iptm_dir/${gene_name}_iptm.txt"
averaged_file="$iptm_dir/${gene_name}_averaged_iptm.txt"

# Optional: ipTM cutoff value
cutoff=0.000

# Create the output file
> "$iptm_file"

# Extract ipTM scores from each JSON
for json_file in "$gene_dir"/*seed*.json; do
    filename=$(basename "$json_file")
    name=$(echo "$filename" | cut -f1,2 -d '_')
    num=$(awk 'END {print $NF}' "$json_file" | sed 's/[^0-9.]//g')
    echo "$name $num" >> "$iptm_file"
done

# Average ipTM scores
awk '{seen[$1]+=$2; count[$1]++} END{for (x in seen) print x, seen[x]/count[x]}' "$iptm_file" > "$averaged_file"

# Uncomment below to filter by threshold
# awk -v c=$cutoff '$2 >= c {print $1}' "$averaged_file" > "$iptm_dir/${gene_name}_filtered_iptm.txt"
# awk -v c=$cutoff '$2 >= c {print $1, $2}' "$averaged_file" > "$iptm_dir/${gene_name}_filtered_iptm_scores.txt"

echo "$gene_name ipTM parsing complete. Results saved in: $iptm_dir"
