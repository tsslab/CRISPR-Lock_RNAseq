#!/bin/sh

# Load package
module add rna-star/2.6.1d
module add samtools/1.9

# Set working directory
# cd /project/tsslab/mhanifi/RNAseq_data/fastq_trimmed
# Need to indicate full path in STAR

# Run TrimGalore
STAR --runThreadN 8 \
     --genomeDir /project/tsslab/mhanifi/genome_reference/GRCh38_Genome_UCSC_STAR_indexed \
     --readFilesCommand zcat \
     --readFilesIn /project/tsslab/mhanifi/RNAseq_data/fastq_trimmed/Sample_18_val_1.fq.gz /project/tsslab/mhanifi/RNAseq_data/fastq_trimmed/Sample_18_val_2.fq.gz \
     --outFileNamePrefix /project/tsslab/mhanifi/RNAseq_data/BAM/Sample_18. \
     --sjdbFileChrStartEnd /project/tsslab/mhanifi/RNAseq_data/SJ/*SJ.out.tab /project/tsslab/mhanifi/RNAseq_data/Metadata/sj.txt \
     --outSAMtype BAM SortedByCoordinate \
     --outSAMattributes NH HI AS nM XS \
     --quantMode TranscriptomeSAM \
     --limitSjdbInsertNsj 1500000

# Index BAM
samtools index /project/tsslab/mhanifi/RNAseq_data/BAM/Sample_18.Aligned.sortedByCoord.out.bam

# SJ file to another folder
#cp /project/tsslab/mhanifi/RNAseq_data/BAM/Sample_18.SJ.out.tab /project/tsslab/mhanifi/RNAseq_data/SJ_2ndPass/

# Remove intermediate files
rm -rf /project/tsslab/mhanifi/RNAseq_data/BAM/Sample_18.Log.progress.out
rm -rf /project/tsslab/mhanifi/RNAseq_data/BAM/Sample_18.Log.out
rm -rf /project/tsslab/mhanifi/RNAseq_data/BAM/Sample_18.Log.final.out
rm -rf /project/tsslab/mhanifi/RNAseq_data/BAM/Sample_18._STARgenome
