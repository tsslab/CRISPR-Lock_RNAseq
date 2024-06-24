#!/bin/sh

cd /project/tsslab/mhanifi/RNAseq_data/BAM/

# Load package
module add samtools/1.9

samtools sort -n Sample_25.Aligned.sortedByCoord.out.bam \
              -o Sample_25.Aligned.sortedByName.out.bam \
              -@ 4


