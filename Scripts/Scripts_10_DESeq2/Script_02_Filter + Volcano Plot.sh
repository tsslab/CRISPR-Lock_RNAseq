# Load packages
library(plyr)
library(ggplot2)

# Check genotypes to determine min. sample threshold
    # Read phenoData
    path <- "/Users/seanwen/Documents/Hanifi/featureCounts/"
    file <- "Counts_phenoData_TechRepMerged.txt"
    df.pheno <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, check.names=FALSE)
    
    # Check sample size
    table(df.pheno$group)
    
# Define genotypes
    # Path to original DESeq2 output
    path <- "/Users/seanwen/Documents/Hanifi/DESeq2/Tables/"
    files <- list.files(path)

    # Reference group
    . <- strsplit(files, split=" vs ", fixed=TRUE)
    . <- sapply(., function(x) {x[2]})
    . <- gsub(".txt", "", ., fixed=TRUE)
    ref <- .
    
    # Non-referenec group
    . <- strsplit(files, split=" vs ", fixed=TRUE)
    . <- sapply(., function(x) {x[1]})
    non.ref <- .

pb <- txtProgressBar(1, length(non.ref), style=3)

for(i in 1:length(non.ref)) {

    # Read results
    path <- "/Users/seanwen/Documents/Hanifi/DESeq2/Tables/"
    file <- paste(non.ref[i], " vs ", ref[i], ".txt", sep="")
    df <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")
    
    # Remove missing padj
    df <- df[!is.na(df$padj), ]

    # Subset sufficiently expressed genes
    df <- df[which((df$refExp >= 3 | df$non.refExp >= 3)), ]
    
    # Re-code very small p-values
    head(sort(df$padj))
    
    if(sort(df$padj)[[1]]==0) {
    
        # Find second smallest p-value
        . <- df$padj[(df$padj != 0)]
        . <- sort(.)
        
        # Replace 0
        df$padj[which(df$padj==0)] <- .[1]
    
    }

    # Re-adjust p-valus
    #df$padj <- p.adjust(df$pvalue, method="fdr", n=length(df$pvalue))
    
    # Remove outliers from volcano plot (check first initial volcano plot for any outliers)
    #index <- which(df$log2FoldChange < 18)
    #df <- df[index, ]

    # Indicate significant genes' direction
    df$sig.genes.direction <- NA
    df$sig.genes.direction[which(df$log2FoldChange > 0.1 & df$padj < 0.01)] <- "Up"
    df$sig.genes.direction[which(df$log2FoldChange < -0.1 & df$padj < 0.01)] <- "Down"
    df$sig.genes.direction[is.na(df$sig.genes.direction)] <- "n.s."
    df$sig.genes.direction <- factor(df$sig.genes.direction, levels=c("Up", "Down", "n.s."))
    table(df$sig.genes.direction)

    # Transform p-values
    df$padj.log <- -log10(df$padj)

    # Order by sig genes direction (for aesthetic purpose)
    df <- df[order(df$sig.genes.direction, decreasing=TRUE), ]

    # Reorder direction for aesthetic purpose
    df <- df[order(df$sig.genes.direction, decreasing=TRUE), ]

    # Censor lfcSE for non-sig genes
    #df$lfcSE[which(df$sig.genes.direction=="n.s.")] <- 0
    
    # Remove DE with very large FC
    #df <- df[which(abs(df$log2FoldChange) < 15), ]

    # Scatterplot
        # Definition
        data <- df
        #data <- df[which(df$log2FoldChange < 15 & df$log2FoldChange > -15), ]
        #x <- data$log2FoldChange.volcano.plot
        x <- data$log2FoldChange
        y <- data$padj.log
        z <- data$sig.genes.direction
        #z2 <- data$lfcSE
        #label <- data$gene_name
        maintitle <- ""
        xtitle <- "log2(FC)"
        ytitle <- "-log10(FDR)"
        legendtitle.color <- "Direction"
        legendtitle.size <- "log2(FC-SE)"
        #ymin <- round(min(c(min(y) * -1, max(y)) * -1), digits=0)
        #ymax <- round(max(c(min(y) * -1, max(y)) * 1), digits=0)
        yinterval <- 2
        yintercept <- -log10(0.10)
        . <- ceiling(max(c(abs(min(x)), abs(max(x)))))
        
        xmin <- floor(min(x)) ; xmax <- ceiling(max(x)) ; xinterval <- 2
 
        if((xmin %% 2) != 0) {
             
             xmin <- xmin - 1 ; xmax <- xmax + 1
             
        }
        
        sig.up <- which(data$sig.genes.direction=="Up")
        sig.down <- which(data$sig.genes.direction=="Down")
        
        if(length(sig.up) != 0 & length(sig.down) != 0) {
        
            col.breaks <- c("red", "blue", "gray")
            
        } else if(length(sig.up) != 0 & length(sig.down) == 0) {
        
            col.breaks <- c("red", "gray")
            
        } else if(length(sig.up) == 0 & length(sig.down) != 0) {
        
            col.breaks <- c("blue", "gray")
        
        } else if(length(sig.up) == 0 & length(sig.down) == 0) {
        
            col.breaks <- "gray"
        
        }
        
        #ymin <- 0 ; ymax <- max(y) + 10
        
        # Plot
        plot <- ggplot(data, aes(x=x, y=y)) +
                   geom_point(shape=20, mapping=aes(color=z), size=0.1) +
                   geom_hline(yintercept=-log10(0.01), linetype="dashed", color="black", size=0.25) +
                   geom_vline(xintercept=c(-0.10, 0.10), linetype="dashed", color="black", size=0.25) +
                   scale_colour_manual(values=col.breaks) +
                   #scale_y_continuous(limits=c(ymin, ymax)) +
                   labs(title=maintitle, x=xtitle, y=ytitle, color=legendtitle.color) +
                    theme(panel.grid.major = element_blank(),
                        panel.grid.minor = element_blank(),
                        panel.background = element_blank(),
                        panel.border=element_blank(),
                        plot.title=element_text(hjust = 0.5, size=15),
                        plot.subtitle=element_text(hjust = 0.5, size=15),
                        axis.line.y.left = element_line(color="black"),
                        axis.line.x = element_line(color="black"),
                        axis.title=element_text(size=12),
                        axis.text=element_text(size=12),
                        axis.text.x=element_text(size=10, colour="black"),
                        axis.text.y=element_text(size=10, colour="black"),
                        #legend.position="none",
                        legend.title=element_text(size=8),
                        legend.text=element_text(size=8)
                        ) +
                guides(color=guide_legend(override.aes=list(size=2)))
                        
        # Save plot
        path <- "/Users/seanwen/Documents/Hanifi/DESeq2/Volcano Plot/"
        file <- paste(non.ref[i], " vs ", ref[i], ".png", sep="")
        ggsave(paste(path, file, sep=""), plot, width=3.5, height=3)
        
    # Tabulate num. sig. genes
    . <- as.data.frame(table(df$sig.genes.direction))
    names(.) <- c("direction", "n.sig.genes")

    # Save file
    path <- "/Users/seanwen/Documents/Hanifi/DESeq2/Volcano Plot/"
    file <- paste(non.ref[i], " vs ", ref[i], "_Summary.txt", sep="")
    write.table(., paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)

    # Save file
    df <- df[order(df$pval), ]

    path <- "/Users/seanwen/Documents/Hanifi/DESeq2/Tables_Filtered/"
    file <- paste(non.ref[i], " vs ", ref[i], ".txt", sep="")
    write.table(df, paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)
    
    # Track progress
    setTxtProgressBar(pb, i)

}
