#!/bin/sh

# Load package
module add stringtie/2.1.4

cd /project/tsslab/mhanifi/RNAseq_data/

stringtie --merge GTF/individual_samples/*.gtf \
          -i \
          -o GTF/Merged.gtf \
          -p 4 \
          -G /project/tsslab/mhanifi/genome_reference/GRCh38_Transcriptome_GENCODE/gencode.v31.annotation.gtf
          

