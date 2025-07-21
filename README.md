# LocalColabFold Batch Pipeline

This repository provides a set of shell scripts to run ColabFold multimer predictions in batch mode. The pipeline:

1. Combine query and prey FASTA files into ColabFold-compatible CSV inputs.
2. Runs ColabFold multimer predictions on these CSV files.
3. Parses the resulting ipTM scores and averages them for each query-prey pair.

---

## Requirements

- [LocalColabFold](https://github.com/YoshitakaMo/localcolabfold) installed and `colabfold_batch` accessible in your `$PATH`.
- Your FASTA files organized appropriately (see example).

---

## Usage

Make scripts executable:

```bash
chmod +x run_pipeline.sh scripts/*.sh
```

Run the pipeline:

```bash
./run_pipeline.sh <query_fasta_dir> <prey_fasta_dir>
```

<query_fasta_dir>: Directory containing exactly one .fas file (your query/bait sequence)

<prey_fasta_dir>: Directory containing one or more .fas files (your prey sequences)

Example:

```bash
./run_pipeline.sh YLR001C YNL123W prey_list.txt /data/proteins/cds/
```

## Notes

The pipeline assumes your query FASTA file is located in <prey_fasta_directory>/<systematic_name>.fas. Please note they need the .fas extension

Modify the scripts if you want to change output locations or parameters.

You can run individual steps separately using the scripts in the scripts directory.

You can split a file containing multiple fasta sequences into individual .fas files using splitter.sh.
