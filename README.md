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
./run_pipeline.sh <gene_name> <systematic_name> <prey_list_file> <prey_fasta_directory>
```

<gene_name>: Your gene/project name (used for output directories).

<systematic_name>: Systematic name corresponding to the query FASTA file.

<prey_list_file>: Text file listing prey proteins (used by batch_run.sh).

<prey_fasta_directory>: Path to the directory containing prey FASTA files.

Example:

```bash
./run_pipeline.sh YLR001C YNL123W prey_list.txt /data/proteins/cds/
```

## Notes

The pipeline assumes your query FASTA file is located in <prey_fasta_directory>/<systematic_name>.fas.

Modify the scripts if you want to change output locations or parameters.

You can run individual steps separately using the scripts in the scripts directory.
