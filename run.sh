#!/bin/bash
#SBATCH --job-name=esm_conformers
#SBATCH --output=logs/%x-%j.out
#SBATCH --partition=long
#SBATCH --time=00:59:00
#SBATCH --gpus=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=8GB
#SBATCH --partition long

# Activate conda environment
module --force purge
module load cuda/11.8 python/3.9

# Activate virtual environment
source .venv/bin/activate

JOBNAME=bpti
OUTDIR=/home/mila/s/stephen.lu/scratch/alphaflow_conformers
FASTA=/home/mila/s/stephen.lu/proteins/data/test_set/bpti/bpti.fasta
N=100
WEIGHTS=/home/mila/s/stephen.lu/proteins/alphaflow/assets/alphaflow_md_base_202402.pt

# First, obtain the msa for the sequences
python scripts/mmseqs_query.py --fasta $FASTA --outdir $OUTDIR/__msa__

# Next, generate the conformers
python predict.py \
    --mode alphafold \
    --fasta $FASTA \
    --msa_dir $OUTDIR/__msa__ \
    --weights $WEIGHTS \
    --samples $N \
    --outpdb $OUTDIR/$JOBNAME 
