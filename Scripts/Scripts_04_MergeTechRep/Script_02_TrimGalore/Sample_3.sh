#!/bin/sh

# Load package
module add trim_galore/0.6.5

# Set working directory
cd /project/tsslab/mhanifi/RNAseq_data/

# Run TrimGalore
trim_galore -j 3 \
            -q 20 \
            --paired fastq_merged/Sample_3_R1.fq.gz fastq_merged/Sample_3_R2.fq.gz \
            -o fastq_trimmed/ \
            --basename Sample_3
