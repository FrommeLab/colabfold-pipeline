#!/bin/bash

# RCV. Last updated 4 Dec 2025 2025
# Usage: ./csplitter.sh input [output_directory]

set -e

# Check input
if [ -z "$1" ]; then
    echo "Usage: $0 input_fasta.txt [output_directory]"
    exit 1
fi

input_file="$1"
output_dir="${2:-output_fastas}"

if [ ! -f "$input_file" ]; then
    echo "Error: Input file '$input_file' not found."
    exit 1
fi

mkdir -p "$output_dir"

# Process the FASTA file
awk -v RS=">" -v FS="\n" -v outdir="$output_dir" '
    NR > 1 {
	header = $1;
        seq = "";

        # Concatenate sequence lines
        for (i = 2; i <= NF; i++) seq = seq $i;

        # Match GN=gene_name and exclude (Fragment)
        if (match(header, /GN=([A-Za-z0-9_]+)/, m) && header !~ /\(Fragment\)/) {
            gene = m[1];

            # Keep the longest sequence for each gene
            if (!(gene in sequences) || length(seq) > length(sequences[gene])) {
                sequences[gene] = seq;
            }
	}
    }
    END {
	for (gene in sequences) {
            file = outdir "/" gene ".fas";
            print sequences[gene] > file;
        }
    }
' "$input_file"

echo "Done. Split FASTA files written to: $output_dir"
