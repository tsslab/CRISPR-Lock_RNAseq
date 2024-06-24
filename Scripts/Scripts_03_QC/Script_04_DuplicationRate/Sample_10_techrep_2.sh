#!/bin/sh

# Load modules
module load picard-tools/2.3.0

cd /project/tsslab/mhanifi/RNAseq_data/

# Mark and remove duplicates
MarkDuplicates CREATE_INDEX=False \
               I=BAM/Sample_10_techrep_2.Aligned.sortedByCoord.out.bam \
               O=BAM/Sample_10_techrep_2.Aligned.sortedByCoord_DupMarked.out.bam \
               M=QC/DupMetric/Sample_10_techrep_2.Aligned.sortedByCoord_DupMarked.metrics.txt \
               REMOVE_DUPLICATES=False

# Remove intermediate files
rm -rf BAM/Sample_10_techrep_2.Aligned.sortedByCoord_DupMarked.out.bam
