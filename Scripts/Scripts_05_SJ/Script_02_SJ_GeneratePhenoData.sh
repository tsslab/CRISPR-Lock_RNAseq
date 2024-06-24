# Load packages
library(data.table)
library(gdata)
library(plyr)

# Read file
path <- "/Users/seanwen/Documents/Hanifi/SJ/"
file <- "SJ.txt"
df <- as.data.frame(fread(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA"))

# Read metadata
path <- "/Users/seanwen/Documents/Hanifi/Metadata/"
file <- "RNAseq Metadata_SeanEdit.xlsx"
md <- read.xls(paste(path, file, sep=""), sheet=3, header=TRUE, stringsAsFactors=FALSE)

# Annotate metadata
df.pheno <- data.frame("sample.id"=names(df)[-1], stringsAsFactors=FALSE)
df.pheno <- join(df.pheno, md, by="sample.id", type="left")

# Check alignment
table(names(df)[-1]==df.pheno$sample.id)

# Save file
path <- "/Users/seanwen/Documents/Hanifi/SJ/"
file <- "SJ_phenoData.txt"
write.table(df.pheno, paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)
