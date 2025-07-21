#!/bin/bash

# RCV. Last updated 21 July 2025
# Usage: ./iptm_parser.sh <gene_name>

set -e

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <gene_name>"
    exit 1
fi

gene="$1"
cwd=$(pwd)
outdir="$cwd/$gene"
iptm_file="$outdir/${gene}_iptm.txt"
avg_file="$outdir/${gene}_averaged_iptm.txt"

#Clear or create iptm output
> "$iptm_file"

#Extract scores from JSONs
for file in "$outdir"/*seed*.json; do
    filename=$(basename "$file")
    name=$(echo "$filename" | cut -f1,2 -d '_')
    score=$(awk 'END {print $NF}' "$file" | sed 's/[^0-9.]//g')
    echo "$name $score" >> "$iptm_file"
done

#Average scores
awk '{seen[$1]+=$2; count[$1]++} END{for (x in seen) print x, seen[x]/count[x]}' "$iptm_file" > "$avg_file"

# Optional: filter by threshold (uncomment if desired)
# threshold=0.5
# awk -v b="$threshold" '$2 >= b {print $1}' "$avg_file" > "$outdir/${gene}_filtered_iptm.txt"
# awk -v b="$threshold" '$2 >= b {print $1,$2}' "$avg_file" > "$outdir/${gene}_filtered_iptm_scores.txt"

echo "$gene parsing complete. Results:"
echo " - Raw scores: $iptm_file"
echo " - Averaged scores: $avg_file"
