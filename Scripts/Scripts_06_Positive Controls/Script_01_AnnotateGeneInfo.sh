# Load packages
library(data.table)
library(plyr)

# Read exon coordinate file
path <- "/Users/seanwen/Documents/Hanifi/Metadata/"
file <- "List of reversed splicing events (RT-PCR confirmed)_SeanEdit.txt"
df <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE)

# Annotate gene_id, gene_type
    # Read GTF
    path <- "/Users/seanwen/Documents/U2AF1_2019/GTF/"
    file <- "gencode.v31.annotation.gtf"
    gtf <- as.data.frame(fread(paste(path, file, sep=""), sep="\t", header=FALSE, stringsAsFactors=FALSE, quote=""))

    # Subset genes
    gtf <- gtf[which(gtf$V3=="gene"), ]

    # Subset selected attributes
        # gene_name
        . <- strsplit(gtf$V9, split=";")
        . <- sapply(., function(x) grep("gene_name", x, value=TRUE))
        . <- gsub("gene_name", "", .)
        . <- gsub(" ", "", .)
        . <- gsub("\"", "", .)
        head(.)
        gtf$gene_short_name <- .
        
        # gene_id
        . <- strsplit(gtf$V9, split=";")
        . <- sapply(., function(x) grep("gene_id", x, value=TRUE))
        . <- gsub("gene_id", "", .)
        . <- gsub(" ", "", .)
        . <- gsub("\"", "", .)
        head(.)
        gtf$gene_id <- .
        
        # gene_type
        . <- strsplit(gtf$V9, split=";")
        . <- sapply(., function(x) grep("gene_type", x, value=TRUE))
        . <- gsub("gene_type", "", .)
        . <- gsub(" ", "", .)
        . <- gsub("\"", "", .)
        head(.)
        gtf$gene_type <- .

    # Check for non-matches
    setdiff(df$gene_short_name, gtf$gene_short_name)

    # Annotate
    df <- join(df, gtf[,c("gene_short_name", "gene_id", "gene_type")], by="gene_short_name", type="left")
    
# Format to match MARVEL input
cols <- c("tran_id", "gene_id", "gene_short_name", "gene_type")
df <- df[, cols]

# Save file
path <- "/Users/seanwen/Documents/Hanifi/Positive Controls/"
file <- "SE_featureData.txt"
write.table(df, paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)
