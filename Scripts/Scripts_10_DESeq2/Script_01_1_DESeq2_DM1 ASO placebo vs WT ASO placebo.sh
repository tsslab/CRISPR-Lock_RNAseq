# Load packages
library(DESeq2)
library(plyr)

# Read files
    # Matrix (counts)
    path <- "/Users/seanwen/Documents/Hanifi/featureCounts/"
    file <- "Counts_TechRepMerged.txt"
    df <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, check.names=FALSE)
    
    row.names(df) <- df$gene_id
    df$gene_id <- NULL
    
    # Matrix (CPM)
    path <- "/Users/seanwen/Documents/Hanifi/featureCounts/"
    file <- "CPM-log2_TechRepMerged.txt"
    df.cpm <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, check.names=FALSE)
    
    row.names(df.cpm) <- df.cpm$gene_id
    df.cpm$gene_id <- NULL
    
    # featureData
    path <- "/Users/seanwen/Documents/Hanifi/featureCounts/"
    file <- "Counts_featureData_TechRepMerged.txt"
    df.feature <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, check.names=FALSE)

    # phenoData
    path <- "/Users/seanwen/Documents/Hanifi/featureCounts/"
    file <- "Counts_phenoData_TechRepMerged.txt"
    df.pheno <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, check.names=FALSE)
    
# Check alignment
table(row.names(df)==row.names(df.cpm))
table(names(df)==names(df.cpm))
table(row.names(df)==df.feature$gene_id)
table(names(df)==df.pheno$sample.id)

# Define sample groups
table(df.pheno$group)
ref <- "WT ASO placebo"
non.ref <- "DM1 ASO placebo"

# Subset relevant groups
df.pheno <- df.pheno[which(df.pheno$group %in% c(ref, non.ref)), ]
df <- df[, which(names(df) %in% df.pheno$sample.id)]
df.cpm <- df.cpm[, which(names(df.cpm) %in% df.pheno$sample.id)]

# Set factor levels
df.pheno$group <- factor(df.pheno$group, levels=c(ref, non.ref))
table(df.pheno$group)

################################################################################

# Subset expressed genes
. <- apply(df, 1, function(x) {sum(x >= 1)})
gene_ids <- names(.)[which(. != 0)]
df.feature <- df.feature[which(df.feature$gene_id %in% gene_ids), ]
df <- df[df.feature$gene_id, ]

# DE
deseq2 <- DESeqDataSetFromMatrix(countData=df,
                                 colData=df.pheno,
                                 design=~group)
out <- DESeq(deseq2)
out <- results(out,
               contrast=c("group", non.ref, ref),
               pAdjustMethod="fdr",
               format="DataFrame",
               )
out <- as.data.frame(out)
               
# Order by fdr
#out <- out[!is.na(out$padj), ]
out <- out[order(out$pvalue), ]

# Annotate with gene info
out$gene_id <- row.names(out)
out <- join(out, df.feature, by="gene_id", type="left")
out <- out[,c("gene_id", "gene_short_name", "gene_type", "baseMean", "log2FoldChange", "lfcSE", "stat", "pvalue", "padj")]

# Compute mean expression
    # ref
    sample.ids <- df.pheno[which(df.pheno$group==ref), "sample.id"]
    df.small <- df.cpm[, sample.ids]
    . <- apply(df.small, 1, function(x) {mean(x)})
    . <- data.frame("gene_id"=names(.), "refMean"=., stringsAsFactors=FALSE)
    out <- join(out, ., by="gene_id", type="left")
    
    # non.ref
    sample.ids <- df.pheno[which(df.pheno$group==non.ref), "sample.id"]
    df.small <- df.cpm[, sample.ids]
    . <- apply(df.small, 1, function(x) {mean(x)})
    . <- data.frame("gene_id"=names(.), "non.refMean"=., stringsAsFactors=FALSE)
    out <- join(out, ., by="gene_id", type="left")
    
# Compute samples expressing genes
    # ref
    sample.ids <- df.pheno[which(df.pheno$group==ref), "sample.id"]
    df.small <- df.cpm[, sample.ids]
    . <- apply(df.small, 1, function(x) {sum(x >= 1)})
    . <- data.frame("gene_id"=names(.), "refExp"=., stringsAsFactors=FALSE)
    out <- join(out, ., by="gene_id", type="left")

    # non-ref
    sample.ids <- df.pheno[which(df.pheno$group==non.ref), "sample.id"]
    df.small <- df.cpm[, sample.ids]
    . <- apply(df.small, 1, function(x) {sum(x >= 1)})
    . <- data.frame("gene_id"=names(.), "non.refExp"=., stringsAsFactors=FALSE)
    out <- join(out, ., by="gene_id", type="left")

# Save file
path <- "/Users/seanwen/Documents/Hanifi/DESeq2/Tables/"
file <- paste(non.ref, " vs ", ref, ".txt", sep="")
write.table(out, paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)

