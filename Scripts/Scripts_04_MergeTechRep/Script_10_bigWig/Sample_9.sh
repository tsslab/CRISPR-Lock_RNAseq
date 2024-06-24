#!/bin/sh

# Load modules
module load deeptools/current

# Set sample directory
cd /project/tsslab/mhanifi/RNAseq_data/

bamCoverage -b BAM/Sample_9.Aligned.sortedByCoord.out.bam \
            -o bigWig/Sample_9.SeqDepthNorm.bw \
            -p 1
