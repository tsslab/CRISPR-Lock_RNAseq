# Read metadata
path <- "/Users/seanwen/Documents/Hanifi/Metadata/"
file <- "RNAseq Metadata_SeanEdit.txt"
df <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE)

# Add path to BAM file
sample.ids <- df$sample.id
bam <- paste("/project/tsslab/mhanifi/RNAseq_data/BAM/", sample.ids, ".Aligned.sortedByName.out.bam", sep="")
bam <- paste(bam, collapse=" ")

print(bam)
