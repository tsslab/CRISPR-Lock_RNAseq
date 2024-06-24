# Load packages
library(data.table)
library(plyr)
library(FactoMineR)
library(factoextra)

# Read CPM files
    # Matrix
    path <- "/Users/seanwen/Documents/Hanifi/featureCounts/"
    file <- "CPM-log2_TechRepMerged.txt"
    df <- as.data.frame(fread(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, check.names=FALSE))
    
    row.names(df) <- df$gene_id
    df$gene_id <- NULL
    
    # phenoData
    path <- "/Users/seanwen/Documents/Hanifi/featureCounts/"
    file <- "Counts_phenoData_TechRepMerged.txt"
    df.pheno <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE)

    # featureData
    path <- "/Users/seanwen/Documents/Hanifi/featureCounts/"
    file <- "Counts_featureData_TechRepMerged.txt"
    df.feature <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE)

# Subset +ve ctrl genes
    # Read file
    path <- "/Users/seanwen/Documents/Hanifi/Positive Controls/"
    file <- "SE_featureData.txt"
    df.feature.se <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")
    
    # Retrieve genes
    gene_ids <- df.feature.se$gene_id
    
    # Subset
    df.feature <- df.feature[which(df.feature$gene_id %in% gene_ids), ]
    df <- df[df.feature$gene_id, ]

# Dotplot
gene_ids <- df.feature$gene_id
gene_short_names <- df.feature$gene_short_name

for(i in 1:length(gene_ids)) {

    # Subset PSI values
    . <- df[gene_ids[i], ]
    . <- as.data.frame(t(.))
    names(.) <- "exp"
    .$sample.id <- row.names(.)
    row.names(.) <- NULL
    . <- .[,c("sample.id", "exp")]
    results <- .
    
    # Annotate sample group
    results <- join(results, df.pheno[,c("sample.id", "group")], by="sample.id", type="left")
    
    # Set factor levels
    table(results$group)
    levels <- c("WT untreated",
                "DM1 untreated",
                "WT ASO placebo",
                "DM1 ASO placebo",
                "DM1 ASO low dose treatment",
                "DM1 ASO high dose treatment",
                "WT dCas13 placebo",
                "DM1 dCas13 placebo",
                "DM1 dCas13 treated"
                )
                
    labels <- c("WT untreated",
                "DM1 untreated",
                "WT ASO placebo",
                "DM1 ASO placebo",
                "DM1 ASO low",
                "DM1 ASO high",
                "WT dCas13 placebo",
                "DM1 dCas13 placebo",
                "DM1 dCas13 treated"
                )
                
    results$group <- factor(results$group, levels=levels, labels=labels)
        
    # Dotplot
    data <- results
    x <- data$group
    y <- data$exp
    z <- data$group
    maintitle <- gene_short_names[i]
    ytitle <- "log2(CPM + 1)"
    xtitle <- ""
    #xlabels <- n.cells$label


    # Plot
    plot <- ggplot() +
        geom_jitter(data, mapping=aes(x=x, y=y, fill=z), position=position_jitter(width=0.1, height=0), color="black", pch=21, size=3, alpha=0.50, stroke=0.1) +
        stat_summary(data, mapping=aes(x=x, y=y), geom="crossbar", fun="mean", color="red", size=0.25, width=0.5) +
        #scale_fill_manual(values=cols) +
        #scale_x_discrete(labels=xlabels) +
        scale_y_continuous(breaks=seq(0, 10, by=2), limits=c(0, 10)) +
        labs(title=maintitle, x=xtitle, y=ytitle) +
        theme(panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            panel.background = element_blank(),
            panel.border=element_blank(),
            plot.title=element_text(hjust = 0.5, size=12),
            plot.subtitle=element_text(hjust = 0.5, size=12),
            axis.line.y.left = element_line(color="black"),
            axis.line.x = element_line(color="black"),
            axis.title=element_text(size=10),
            axis.text=element_text(size=10),
            axis.text.x=element_text(size=6, colour="black", angle=45, hjust=1, vjust=1),
            axis.text.y=element_text(size=10, colour="black"),
            legend.position="none",
            legend.title=element_text(size=10),
            legend.text=element_text(size=10)
            )
    
    # Save file
    path <- "/Users/seanwen/Documents/Hanifi/Positive Controls/Plots_Gene/"
    file <- paste(gene_short_names[i], ".pdf", sep="")
    ggsave(paste(path, file, sep=""), plot, width=4, height=4)

}
