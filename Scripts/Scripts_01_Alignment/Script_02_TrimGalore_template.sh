#!/bin/sh

# Load package
module add trim_galore/0.6.5

# Set working directory
cd /project/tsslab/mhanifi/RNAseq_data/

# Run TrimGalore
trim_galore -j 3 \
            -q 20 \
            --paired All_samples/FASTQ_NAME_1 All_samples/FASTQ_NAME_2 \
            -o fastq_trimmed/ \
            --basename SAMPLE_NAME
