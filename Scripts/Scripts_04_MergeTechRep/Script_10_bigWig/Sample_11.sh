#!/bin/sh

# Load modules
module load deeptools/current

# Set sample directory
cd /project/tsslab/mhanifi/RNAseq_data/

bamCoverage -b BAM/Sample_11.Aligned.sortedByCoord.out.bam \
            -o bigWig/Sample_11.SeqDepthNorm.bw \
            -p 1
