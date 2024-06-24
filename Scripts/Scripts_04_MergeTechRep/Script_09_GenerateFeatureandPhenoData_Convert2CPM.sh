# Load packages
library(data.table)
library(plyr)
library(gdata)

# Read matrix
path <- "/Users/seanwen/Documents/Hanifi/featureCounts/"
file <- "features_counted_TechRepMerged.txt"
df <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, check.names=FALSE)

#####################################################################
############################ FEATUREDATA ############################
#####################################################################

# Create reference data frame
. <- data.frame("gene_id"=df$Geneid, "gene_length"=df$Length, stringsAsFactors=FALSE)

# Annotate gene name, type
    # Read GTF
    path <- "/Users/seanwen/Documents/U2AF1_2019/GTF/"
    file <- "gencode.v31.annotation.gtf"
    gtf <- as.data.frame(fread(paste(path, file, sep=""), sep="\t", header=FALSE, stringsAsFactors=FALSE, quote=""))

    # Build gene gtference table
        # Subset genes
        gtf <- gtf[which(gtf$V3=="gene"), ]
        
        # Subset selected attributes
            # gene_id
            gene_id <- strsplit(gtf$V9, split=";")
            gene_id <- sapply(gene_id, function(x) grep("gene_id", x, value=TRUE))
            gene_id <- gsub("gene_id", "", gene_id)
            gene_id <- gsub(" ", "", gene_id)
            gene_id <- gsub("\"", "", gene_id)
            head(gene_id)
            
            # gene_name
            gene_name <- strsplit(gtf$V9, split=";")
            gene_name <- sapply(gene_name, function(x) grep("gene_name", x, value=TRUE))
            gene_name <- gsub("gene_name", "", gene_name)
            gene_name <- gsub(" ", "", gene_name)
            gene_name <- gsub("\"", "", gene_name)
            head(gene_name)
            
            # gene_type
            gene_type <- strsplit(gtf$V9, split=";")
            gene_type <- sapply(gene_type, function(x) grep("gene_type", x, value=TRUE))
            gene_type <- gsub("gene_type", "", gene_type)
            gene_type <- gsub(" ", "", gene_type)
            gene_type <- gsub("\"", "", gene_type)
            head(gene_type)

            # Create new columns
            gtf$gene_id <- gene_id
            gtf$gene_name <- gene_name
            gtf$gene_type <- gene_type

            # Keep unique entries
            gtf <- unique(gtf[, c("gene_id", "gene_name", "gene_type")])
            names(gtf)[2] <- "gene_short_name"
            
    # Annotate with attributes
    . <- join(., gtf, by="gene_id", type="left")
    
# Reorder columns
. <- .[,c("gene_id", "gene_short_name", "gene_type", "gene_length")]

# Save file
path <- "/Users/seanwen/Documents/Hanifi/featureCounts/"
file <- "Counts_featureData_TechRepMerged.txt"
write.table(., paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)

# Save file
#path <- "/Users/seanwen/Documents/Hanifi/featureCounts/"
#file <- "CPM_featureData.txt"
#write.table(., paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)

# Remove gene data
row.names(df) <- df$Geneid
df <- df[,-c(1:6)]

#####################################################################
############################## PHENODATA ############################
#####################################################################

# Create sample ids
. <- gsub("/project/tsslab/mhanifi/RNAseq_data/BAM/", "", names(df), fixed=TRUE)
sample.ids <- gsub(".Aligned.sortedByName.out.bam", "", . , fixed=TRUE)
names(df) <- sample.ids

# Create reference data frame
. <- data.frame("sample.id"=sample.ids, stringsAsFactors=FALSE)

# Annotate metadata
    # Read file
    path <- "/Users/seanwen/Documents/Hanifi/Metadata/"
    file <- "RNAseq Metadata_SeanEdit.xlsx"
    md <- read.xls(paste(path, file, sep=""), sheet=3, header=TRUE, stringsAsFactors=FALSE, check.names=FALSE)
    
    # Annotate
    . <- join(., md, by="sample.id", type="left")

# Save file
path <- "/Users/seanwen/Documents/Hanifi/featureCounts/"
file <- "Counts_phenoData_TechRepMerged.txt"
write.table(., paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)

# Save file
#path <- "/Users/seanwen/Documents/Hanifi/featureCounts/"
#file <- "CPM_phenoData.txt"
#write.table(., paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)

#####################################################################
########################## CONVERT TO CPM ###########################
#####################################################################

# Save as new object
df.cpm <- df

# Read featureData
#path <- "/Users/seanwen/Documents/Hanifi/featureCounts/"
#file <- "Counts_featureData.txt"
#df.feature <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE)

# Normalize by gene length
#df.cpm <- sweep(x=df.cpm, MARGIN=1, FUN='/', STATS=(df.feature$gene_length/1000))
    
# Normalize by lib size
. <- apply(df.cpm, 2, function(x) {sum(x)})
df.cpm <- sweep(x=df.cpm, MARGIN=2, FUN='/', STATS=.)

# Scale factor
df.cpm <- df.cpm * 1e6

# Transform values
df.cpm <- log2(df.cpm + 1)

# Add gene_id column
. <- data.frame("gene_id"=row.names(df))
df <- cbind.data.frame(., df)
row.names(df) <- NULL

. <- data.frame("gene_id"=row.names(df.cpm))
df.cpm <- cbind.data.frame(., df.cpm)
row.names(df.cpm) <- NULL

# Write file
path <- "/Users/seanwen/Documents/Hanifi/featureCounts/"
file <- "Counts_TechRepMerged.txt"
write.table(df, paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)

path <- "/Users/seanwen/Documents/Hanifi/featureCounts/"
file <- "CPM-log2_TechRepMerged.txt"
write.table(df.cpm, paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)
