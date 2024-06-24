#!/bin/sh

# Load package
module add samtools/1.9

samtools view -@ 8 -c /project/tsslab/mhanifi/RNAseq_data/BAM/Sample_8_techrep_1.Aligned.sortedByCoord.out.bam chrM > /project/tsslab/mhanifi/RNAseq_data/QC/MT/Sample_8_techrep_1.txt
