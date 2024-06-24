#!/bin/sh

# Set working directory
cd /project/tsslab/mhanifi/RNAseq_data/

# Sample 3
cat All_samples/Sample_3_EKDL210010737-1a_H23TWDSX3_L1_1.fq.gz All_samples/Sample_3_EKDL210010737-1a_HWVNFDSX2_L4_1.fq.gz > fastq_merged/Sample_3_R1.fq.gz

cat All_samples/Sample_3_EKDL210010737-1a_H23TWDSX3_L1_2.fq.gz All_samples/Sample_3_EKDL210010737-1a_HWVNFDSX2_L4_2.fq.gz > fastq_merged/Sample_3_R2.fq.gz

# Sample 6
cat All_samples/Sample_6_Remade_EKDL210010740-1a_H23TWDSX3_L1_1.fq.gz All_samples/Sample_6_Remade_EKDL210010740-1a_HWVNFDSX2_L3_1.fq.gz > fastq_merged/Sample_6_R1.fq.gz

cat All_samples/Sample_6_Remade_EKDL210010740-1a_H23TWDSX3_L1_2.fq.gz All_samples/Sample_6_Remade_EKDL210010740-1a_HWVNFDSX2_L3_2.fq.gz > fastq_merged/Sample_6_R2.fq.gz

# Sample 8
cat All_samples/Sample_8_EKDL210010742-1a_H23TWDSX3_L1_1.fq.gz All_samples/Sample_8_EKDL210010742-1a_HWVNFDSX2_L4_1.fq.gz > fastq_merged/Sample_8_R1.fq.gz

cat All_samples/Sample_8_EKDL210010742-1a_H23TWDSX3_L1_2.fq.gz All_samples/Sample_8_EKDL210010742-1a_HWVNFDSX2_L4_2.fq.gz > fastq_merged/Sample_8_R2.fq.gz

# Sample 10
cat All_samples/Sample_10_EKDL210010744-1a_H23TWDSX3_L1_1.fq.gz All_samples/Sample_10_EKDL210010744-1a_HWVNFDSX2_L3_1.fq.gz > fastq_merged/Sample_10_R1.fq.gz

cat All_samples/Sample_10_EKDL210010744-1a_H23TWDSX3_L1_2.fq.gz All_samples/Sample_10_EKDL210010744-1a_HWVNFDSX2_L3_2.fq.gz > fastq_merged/Sample_10_R2.fq.gz

# Sample 18
cat All_samples/Sample_18_EKDL210010752-1a_H23TWDSX3_L1_1.fq.gz All_samples/Sample_18_EKDL210010752-1a_HWVNFDSX2_L3_1.fq.gz > fastq_merged/Sample_18_R1.fq.gz

cat All_samples/Sample_18_EKDL210010752-1a_H23TWDSX3_L1_2.fq.gz All_samples/Sample_18_EKDL210010752-1a_HWVNFDSX2_L3_2.fq.gz > fastq_merged/Sample_18_R2.fq.gz
