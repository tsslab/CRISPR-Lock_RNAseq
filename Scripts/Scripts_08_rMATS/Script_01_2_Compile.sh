#!/bin/sh

# Create new directory
mkdir -p /project/tsslab/mhanifi/RNAseq_data/rMATS/ASEvents/

# Copy over GTF
cd /project/tsslab/mhanifi/RNAseq_data/rMATS/
cp fromGTF* ASEvents/

tar -cvzf ASEvents.tar.gz ASEvents/

# Transfer from server to local
scp -rp mhanifi@cbrglogin1.molbiol.ox.ac.uk:/project/tsslab/mhanifi/RNAseq_data/rMATS/ASEvents.tar.gz /Users/seanwen/Documents/Hanifi/rMATS/
