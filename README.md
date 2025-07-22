# LocalColabFold Batch Pipeline

This repository provides a set of shell scripts to run ColabFold multimer predictions in batches. The pipeline:

1. Combine query and prey FASTA files into ColabFold-compatible CSV files.
2. Run Local-ColabFold on these CSVs.
3. Grab the resulting ipTM scores and averages them for each query-prey pair.

---

## Requirements

- [LocalColabFold](https://github.com/YoshitakaMo/localcolabfold) installed and `colabfold_batch` accessible in your `$PATH`.
- please make note of LocalColabFold requirements. A computer with a decent NVIDIA GPU and CUDA drivers are necessary.
- Your FASTA files organized and formatted appropriately (see examples).

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

---

## Outputs

You will get standard ColabFold outputs (PDB format structural predictions, PAE plots of residue-residue confidence, etc). 

You will also get .txt files with either the individual or averaged ipTM scores for each run. For more info on the ipTM score, see a write-up [here](https://www.ebi.ac.uk/training/online/courses/alphafold/inputs-and-outputs/evaluating-alphafolds-predicted-structures-using-confidence-scores/confidence-scores-in-alphafold-multimer/).

## Notes

Modify the scripts if you want to change output locations or ColabFold parameters.

Please note FASTA files need a .fas extension.

You can run individual steps separately using the scripts in the scripts directory.

It's recommended to run this pipeline inside a tmux or screen session, especially when using remote servers or SSH. This prevents disruptions if your SSH connection drops.

To generate a list of preys, I usually grab a list of proteins and their sequences from a database (e.g. UniProt, SGD, FlyBase) and split into individual FASTAs. 
For example, you can grab the entire yeast proteome [here](http://sgd-archive.yeastgenome.org/sequence/S288C_reference/orf_protein/) or human small GTPases [here](https://rest.uniprot.org/uniprotkb/stream?compressed=true&download=true&format=fasta&query=%28%28family%3A%22small+GTPase+superfamily%22%29%29+AND+%28model_organism%3A9606%29). You can use either splitter.sh (if in doubt use this) or csplitter.sh (use for UniProt datasets if you're comfortable, this removes protein fragments and only keeps the largest isoform of a protein) to split one multi-FASTA into many FASTAs.
