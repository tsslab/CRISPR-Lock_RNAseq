#!/bin/sh

# Load modules
module load deeptools/current

# Set sample directory
cd /project/tsslab/mhanifi/RNAseq_data/

bamCoverage -b BAM/Sample_15.Aligned.sortedByCoord.out.bam \
            -o bigWig/Sample_15.SeqDepthNorm.bw \
            -p 1
