#!/bin/bash

# RCV. Last updated 22 July 2025.
# Usage: ./splitter.sh input.fasta [output_directory]

set -e

input_file="$1"
output_dir="${2:-split_fastas}"

if [ -z "$input_file" ] || [ ! -f "$input_file" ]; then
    echo "Usage: $0 input.fasta [output_directory]"
    exit 1
fi

mkdir -p "$output_dir"

awk -v outdir="$output_dir" '
    BEGIN { RS=">"; FS="\n" }
    NR > 1 {
	header_line = $1
        split(header_line, header_parts, " ")
        filename = header_parts[1]
        gsub(/[^A-Za-z0-9_.-]/, "_", filename)  # clean filename

        seq = ""
        for (i = 2; i <= NF; i++) seq = seq $i

        print seq > outdir "/" filename ".fas"
    }
' "$input_file"

echo "Done. Sequences saved to '$output_dir'."
