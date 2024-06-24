#!/bin/sh

module load rna-star/2.6.1d

STAR --runThreadN 4 \
     --runMode genomeGenerate \
     --genomeDir /project/tsslab/mhanifi/genome_reference/GRCh38_Genome_UCSC_STAR_indexed/ \
     --genomeFastaFiles /project/tsslab/mhanifi/genome_reference/GRCh38_Genome_UCSC/GRCh38_Genome_UCSC.fa \
     --sjdbGTFfile /project/tsslab/mhanifi/genome_reference/GRCh38_Transcriptome_GENCODE/gencode.v31.annotation.gtf \
     --sjdbOverhang 100

