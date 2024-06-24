#!/bin/sh

# Load package
module add samtools/1.9

samtools stats -@ 8 /project/tsslab/mhanifi/RNAseq_data/BAM/Sample_8_techrep_2.Aligned.sortedByCoord.out.bam > /project/tsslab/mhanifi/RNAseq_data/QC/Mapped_Reads/Sample_8_techrep_2.txt
