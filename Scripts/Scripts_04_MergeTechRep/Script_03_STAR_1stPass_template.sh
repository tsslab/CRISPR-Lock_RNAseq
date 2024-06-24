#!/bin/sh

# Load package
module add rna-star/2.6.1d

# Run STAR
STAR --runThreadN 8 \
     --genomeDir /project/tsslab/mhanifi/genome_reference/GRCh38_Genome_UCSC_STAR_indexed \
     --readFilesCommand zcat \
     --readFilesIn /project/tsslab/mhanifi/RNAseq_data/fastq_trimmed/SAMPLE_NAME_val_1.fq.gz /project/tsslab/mhanifi/RNAseq_data/fastq_trimmed/SAMPLE_NAME_val_2.fq.gz \
     --outFileNamePrefix /project/tsslab/mhanifi/RNAseq_data/SJ/SAMPLE_NAME. \
     --outSAMtype None

# Remove intermediate files
rm -rf /project/tsslab/mhanifi/RNAseq_data/SJ/SAMPLE_NAME.Log.progress.out
rm -rf /project/tsslab/mhanifi/RNAseq_data/SJ/SAMPLE_NAME.Log.out
rm -rf /project/tsslab/mhanifi/RNAseq_data/SJ/SAMPLE_NAME.Log.final.out
