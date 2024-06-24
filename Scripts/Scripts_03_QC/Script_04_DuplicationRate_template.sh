#!/bin/sh

# Load modules
module load picard-tools/2.3.0

cd /project/tsslab/mhanifi/RNAseq_data/

# Mark and remove duplicates
MarkDuplicates CREATE_INDEX=False \
               I=BAM/SAMPLE_NAME.Aligned.sortedByCoord.out.bam \
               O=BAM/SAMPLE_NAME.Aligned.sortedByCoord_DupMarked.out.bam \
               M=QC/DupMetric/SAMPLE_NAME.Aligned.sortedByCoord_DupMarked.metrics.txt \
               REMOVE_DUPLICATES=False

# Remove intermediate files
rm -rf BAM/SAMPLE_NAME.Aligned.sortedByCoord_DupMarked.out.bam
