#!/bin/sh

# Load modules
module load deeptools/current

# Set sample directory
cd /project/tsslab/mhanifi/RNAseq_data/

bamCoverage -b BAM/Sample_3_techrep_2.Aligned.sortedByCoord.out.bam \
            -o bigWig/Sample_3_techrep_2.SeqDepthNorm.bw \
            -p 1
