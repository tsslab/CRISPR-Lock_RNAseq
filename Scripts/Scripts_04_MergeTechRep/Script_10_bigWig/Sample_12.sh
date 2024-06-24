#!/bin/sh

# Load modules
module load deeptools/current

# Set sample directory
cd /project/tsslab/mhanifi/RNAseq_data/

bamCoverage -b BAM/Sample_12.Aligned.sortedByCoord.out.bam \
            -o bigWig/Sample_12.SeqDepthNorm.bw \
            -p 1
