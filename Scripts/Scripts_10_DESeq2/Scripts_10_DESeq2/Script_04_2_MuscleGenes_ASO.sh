# Load packages
library(plyr)
library(pheatmap)
library(RColorBrewer)

# Read files
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
    
# Set factor levels
table(df.pheno$group)
levels <- c("WT ASO placebo",
            "DM1 ASO placebo",
            "DM1 ASO low dose treatment",
            "DM1 ASO high dose treatment"
            )
labels <- c("WT ASO placebo",
            "DM1 ASO placebo",
            "DM1 ASO low",
            "DM1 ASO high"
            )

df.pheno$group <- factor(df.pheno$group, levels=levels, labels=labels)

df.pheno <- na.omit(df.pheno)

df.cpm <- df.cpm[, df.pheno$sample.id]

# Subset relevant genes
gene_short_names <- c("DMPK", "MYOG", "MYH3", "MYH1", "MYOD1")
setdiff(gene_short_names, df.feature$gene_short_name)
df.feature <- df.feature[which(df.feature$gene_short_name %in% gene_short_names), ]
df.feature$gene_short_name <- factor(df.feature$gene_short_name, levels=gene_short_names)
df.feature <- df.feature[order(df.feature$gene_short_name), ]
df.cpm <- df.cpm[df.feature$gene_id, ]

# Collapse by group using mean
groups <- levels(df.pheno$group)

.list <- list()

for(j in 1:length(groups)) {

    sample.ids <- df.pheno[which(df.pheno$group==groups[j]), "sample.id"]
    df.cpm.small <- df.cpm[, sample.ids]
    . <- apply(df.cpm.small, 1, function(x) {mean(x, na.rm=TRUE)})
    . <- data.frame(.)
    names(.) <- groups[j]
    .list[[j]] <- .
    
}

results <- do.call(cbind.data.frame, .list)

# Replace gene ids with names
table(row.names(results)==df.feature$gene_id)
row.names(results) <- df.feature$gene_short_name

# Heatmap
path <- "/Users/seanwen/Documents/Hanifi/DESeq2/Muscle Genes/"
file <- "Heatmap_ASO.pdf"
pdf(paste(path, file, sep=""), width=2.5, height=3)

pheatmap(results,
         scale="row",
         colorRampPalette(c("white", "blue1", "blue2", "blue4"))(50),
         border_color=NA,
         cluster_cols=FALSE, cluster_rows=FALSE,
         #clustering_distance_cols="maximum", clustering_distance_rows="maximum",
         #clustering_method="median",
         #treeheight_col=10, treeheight_row=0,
         #annotation_col=df.col,
         show_colnames=TRUE, show_rownames=TRUE,
         angle_col=90
         )

dev.off()

