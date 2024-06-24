#!/bin/sh

# Load modules
module load deeptools/current

# Set sample directory
cd /project/tsslab/mhanifi/RNAseq_data/

bamCoverage -b BAM/SAMPLE_NAME.Aligned.sortedByCoord.out.bam \
            -o bigWig/SAMPLE_NAME.SeqDepthNorm.bw \
            -p 1
