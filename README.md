# LocalColabFold Batch Pipeline

This repository provides a set of shell scripts to run ColabFold multimer predictions in batch mode. The pipeline:

1. Combine query and prey FASTA files into ColabFold-compatible CSV inputs.
2. Runs Local-ColabFold on these CSV files.
3. Grabs the resulting ipTM scores and averages them for each query-prey pair.

---

## Requirements

- [LocalColabFold](https://github.com/YoshitakaMo/localcolabfold) installed and `colabfold_batch` accessible in your `$PATH`.
- please make note of LocalColabFold requirements. A computer with a decent NVIDIA GPU and CUDA drivers are necessary.
- Your FASTA files organized appropriately (see examples).

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

The query and prey FASTAs should contain nothing but a protein's primary sequence (asterisks at the end are fine).

Example:

```bash
./run_pipeline.sh /home/user/example_inputs/query_dir /home/user/example_inputs/prey_dir
```

## Notes

Please note FASTA files need a .fas extension

Modify the scripts if you want to change output locations or parameters.

You can run individual steps separately using the scripts in the scripts directory.
