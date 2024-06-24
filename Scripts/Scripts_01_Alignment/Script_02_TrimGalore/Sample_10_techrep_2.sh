#!/bin/sh

# Load package
module add trim_galore/0.6.5

# Set working directory
cd /project/tsslab/mhanifi/RNAseq_data/

# Run TrimGalore
trim_galore -j 3 \
            -q 20 \
            --paired All_samples/Sample_10_EKDL210010744-1a_HWVNFDSX2_L3_1.fq.gz All_samples/Sample_10_EKDL210010744-1a_HWVNFDSX2_L3_2.fq.gz \
            -o fastq_trimmed/ \
            --basename Sample_10_techrep_2
