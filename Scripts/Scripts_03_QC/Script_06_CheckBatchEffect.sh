# Load packages
library(data.table)
library(plyr)
library(FactoMineR)
library(factoextra)

# Read CPM files
    # Matrix
    path <- "/Users/seanwen/Documents/Hanifi/featureCounts/"
    file <- "CPM-log2.txt"
    df <- as.data.frame(fread(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, check.names=FALSE))
    
    row.names(df) <- df$gene_id
    df$gene_id <- NULL
    
    # phenoData
    path <- "/Users/seanwen/Documents/Hanifi/featureCounts/"
    file <- "Counts_phenoData.txt"
    df.pheno <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE)

    # featureData
    path <- "/Users/seanwen/Documents/Hanifi/featureCounts/"
    file <- "Counts_featureData.txt"
    df.feature <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE)

# Subset expressed genes
. <- apply(df, 1, function(x) {sum(x >= 1)})
gene_ids <- names(.)[which(. >=3)]
df.feature <- df.feature[which(df.feature$gene_id %in% gene_ids), ]
df <- df[df.feature$gene_id, ]
table(row.names(df)==df.feature$gene_id)

# Subset top variable genes
. <- apply(df, 1, function(x) {var(x)})
. <- sort(., decreasing=TRUE)
length(.)
n <- round(length(.) * 0.10, digits=0)
gene_ids <- names(.)[c(1:n)]
df.feature <- df.feature[which(df.feature$gene_id %in% gene_ids), ]
df <- df[df.feature$gene_id, ]
table(row.names(df)==df.feature$gene_id)
table(names(df)==df.pheno$sample.id)

# Set factor levels
    # library.prep
    table(df.pheno$library.prep)
    levels <- c("2021-11-15", "2021-11-16", "2021-11-17",
                "2021-11-20", "2021-11-21", "2021-11-25",
                "2021-12-05"
                )
    df.pheno$library.prep <- factor(df.pheno$library.prep, levels=levels)
    
    # group
    table(df.pheno$group)
    levels <- c("WT untreated", "WT ASO placebo", "WT dCas13 placebo",
                "DM1 untreated", "DM1 ASO placebo", "DM1 ASO high dose treatment", "DM1 ASO low dose treatment",
                "DM1 dCas13 placebo", "DM1 dCas13 treated"
                )
    df.pheno$group <- factor(df.pheno$group, levels=levels)
    
    
    
################################################################
############################## PCA #############################
################################################################

# Reduce dimension
res.pca <- PCA(as.data.frame(t(df)), scale.unit=TRUE, ncp=20, graph=FALSE)

# Scatterplot: group
    # Definition
    data <- as.data.frame(res.pca$ind$coord)
    x <- data[,1]
    y <- data[,2]
    z <- df.pheno$library.prep
    maintitle <- ""
    xtitle <- paste("PC1 (", round(get_eigenvalue(res.pca)[1,2], digits=1), "%)" ,sep="")
    ytitle <- paste("PC2 (", round(get_eigenvalue(res.pca)[2,2], digits=1), "%)" ,sep="")
    legendtitle <- "Library Prep."
    
    # Plot (with legends)
    plot <- ggplot() +
        geom_point(data, mapping=aes(x=x, y=y, color=z), size=1.5, alpha=0.75) +
        #scale_color_manual(values=cols) +
        labs(title=maintitle, x=xtitle, y=ytitle, color=legendtitle) +
        theme(panel.grid.major=element_blank(),
            panel.grid.minor=element_blank(),
            panel.background=element_blank(),
            plot.title = element_text(size=12, hjust=0.5),
            axis.line=element_line(colour = "black"),
            axis.title=element_text(size=12),
            axis.text.x=element_text(size=10, colour="black"),
            axis.text.y=element_text(size=10, colour="black"),
            legend.title=element_text(size=8),
            legend.text=element_text(size=8)
            )
            
    # Save plot
    path <- "/Users/seanwen/Documents/Hanifi/CheckBatchEffect/"
    file <- "PCA_Variable Genes_library.prep.pdf"
    ggsave(paste(path, file, sep=""), plot, width=4, height=3.5)

# Scatterplot: group
    # Definition
    data <- as.data.frame(res.pca$ind$coord)
    x <- data[,1]
    y <- data[,2]
    z <- df.pheno$group
    maintitle <- ""
    xtitle <- paste("PC1 (", round(get_eigenvalue(res.pca)[1,2], digits=1), "%)" ,sep="")
    ytitle <- paste("PC2 (", round(get_eigenvalue(res.pca)[2,2], digits=1), "%)" ,sep="")
    legendtitle <- "Group"
    
    # Plot (with legends)
    plot <- ggplot() +
        geom_point(data, mapping=aes(x=x, y=y, color=z), size=1.5, alpha=0.75) +
        #scale_color_manual(values=cols) +
        labs(title=maintitle, x=xtitle, y=ytitle, color=legendtitle) +
        theme(panel.grid.major=element_blank(),
            panel.grid.minor=element_blank(),
            panel.background=element_blank(),
            plot.title = element_text(size=12, hjust=0.5),
            axis.line=element_line(colour = "black"),
            axis.title=element_text(size=12),
            axis.text.x=element_text(size=10, colour="black"),
            axis.text.y=element_text(size=10, colour="black"),
            legend.title=element_text(size=8),
            legend.text=element_text(size=8)
            )
            
    # Save plot
    path <- "/Users/seanwen/Documents/Hanifi/CheckBatchEffect/"
    file <- "PCA_Variable Genes_group.pdf"
    ggsave(paste(path, file, sep=""), plot, width=5, height=3.5)
