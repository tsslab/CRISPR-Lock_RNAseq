#!/bin/sh

cd /project/tsslab/mhanifi/RNAseq_data/BAM/

# Load package
module add samtools/1.9

samtools sort -n SAMPLE_NAME.Aligned.sortedByCoord.out.bam \
              -o SAMPLE_NAME.Aligned.sortedByName.out.bam \
              -@ 8


