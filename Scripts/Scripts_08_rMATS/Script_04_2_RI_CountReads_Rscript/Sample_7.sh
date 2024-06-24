# module load R-base/4.0.1
# module load R-cbrg/202109
# R

# Load packages
library(GenomicAlignments)
library(GenomicRanges)
library(data.table)

# Read BAM file
path <- "/project/tsslab/mhanifi/RNAseq_data/BAM/"
file <- paste("Sample_7", ".Aligned.sortedByCoord.out.bam", sep="")
file.index <- paste("Sample_7", ".Aligned.sortedByCoord.out.bam.bai", sep="")
BAM <- readGAlignments(file=paste(path, file, sep=""),
                       index=paste(path, file.index, sep="")
                       )

class(BAM)

# Read across-samples-collapsed intron set
    # Read file
    path <- "/project/tsslab/mhanifi/RNAseq_data/rMATS/RI/"
    file <- "RI_Coordinates.bed"
    introns <- as.data.frame(fread(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE))

    # Create GRange object
    gr.intron <- GRanges(seqnames=Rle(introns$chr),
                       ranges=IRanges(as.numeric(introns$start),
                                      width=(as.numeric(introns$end)-as.numeric(introns$start))+1,
                                      names=introns$intron.id
                                      )
                       )

    # Check class
    class(gr.intron)

# Count reads mapping to each intron
counts <- countOverlaps(gr.intron, BAM)

# Save into data frame
results <- data.frame("count"=counts, stringsAsFactors=FALSE)
names(results) <- "Sample_7"
row.names(results) <- introns$intron.id

# Save file
path <- "/project/tsslab/mhanifi/RNAseq_data/rMATS/RI/counts_individual_samples/"
file <- paste("Sample_7", ".txt", sep="")
write.table(results, paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=TRUE, quote=FALSE)


