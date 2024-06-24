## Only run this after featureCounts

# Load packages
library(data.table)
library(plyr)

# Read QC file
path <- "/Users/seanwen/Documents/Hanifi/QC/"
file <- "QC.txt"
df <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE)

# Read CPM file
path <- "/Users/seanwen/Documents/Hanifi/featureCounts/"
file <- "CPM-log2.txt"
cpm <- as.data.frame(fread(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE))

row.names(cpm) <- cpm$gene_id
cpm$gene_id <- NULL

# Compute n genes detected
. <- apply(cpm, 2, function(x) {sum(x >=1)})
. <- data.frame("sample.id"=names(.), "n.genes.detected"=as.numeric(.), stringsAsFactors=FALSE)
df <- join(df, ., by="sample.id", type="left")

# Save file (overwrite previous file)
path <- "/Users/seanwen/Documents/Hanifi/QC/"
file <- "QC.txt"
write.table(df, paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)
