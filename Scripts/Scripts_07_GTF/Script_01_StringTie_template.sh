#!/bin/sh

# Load package
module add stringtie/2.1.4

cd /project/tsslab/mhanifi/RNAseq_data/

stringtie    BAM/SAMPLE_NAME.Aligned.sortedByCoord.out.bam \
          -o GTF/individual_samples/SAMPLE_NAME.gtf \
          -p 4 \
          -G /project/tsslab/mhanifi/genome_reference/GRCh38_Transcriptome_GENCODE/gencode.v31.annotation.gtf
          
