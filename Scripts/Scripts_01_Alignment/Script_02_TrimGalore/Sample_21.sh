#!/bin/sh

# Load package
module add trim_galore/0.6.5

# Set working directory
cd /project/tsslab/mhanifi/RNAseq_data/

# Run TrimGalore
trim_galore -j 3 \
            -q 20 \
            --paired All_samples/Sample_21_EKDL210010755-1a_HWVH5DSX2_L2_1.fq.gz All_samples/Sample_21_EKDL210010755-1a_HWVH5DSX2_L2_2.fq.gz \
            -o fastq_trimmed/ \
            --basename Sample_21
