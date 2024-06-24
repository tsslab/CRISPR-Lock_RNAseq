#!/bin/sh

# Load package
module add trim_galore/0.6.5

# Set working directory
cd /project/tsslab/mhanifi/RNAseq_data/

# Run TrimGalore
trim_galore -j 3 \
            -q 20 \
            --paired All_samples/Sample_24_EKDL210010758-1a_HY23LDSX2_L1_1.fq.gz All_samples/Sample_24_EKDL210010758-1a_HY23LDSX2_L1_2.fq.gz \
            -o fastq_trimmed/ \
            --basename Sample_24