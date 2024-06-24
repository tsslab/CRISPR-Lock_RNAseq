#!/bin/sh

module load rmats-turbo/4.1.0

cd /project/tsslab/mhanifi/RNAseq_data/rMATS/

rmats \
    --b1 BAM_1.txt \
    --b2 BAM_1.txt \
    --gtf ../GTF/BRIE_Formatted.gtf \
    --od . \
    --tmp . \
    -t paired \
    --readLength 150 \
    --variable-read-length \
    --nthread 4 \
    --statoff
