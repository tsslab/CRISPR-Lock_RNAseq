# Load packages
library(plyr)
library(ggplot2)
library(gdata)

# Disable scientific notation
options(scipen=999)

# Read QC file
path <- "/Users/seanwen/Documents/Hanifi/QC/"
file <- "QC.txt"
df <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE)

# Annotate metadata
    # Read file
    path <- "/Users/seanwen/Documents/Hanifi/Metadata/"
    file <- "RNAseq Metadata_SeanEdit.xlsx"
    md <- read.xls(paste(path, file, sep=""), sheet=2, header=TRUE, stringsAsFactors=FALSE, check.names=FALSE)

    # Annotate
    df <- join(df, md, by="sample.id", type="left")

# Set factor levels
    # library.prep
    table(df$library.prep.batch)
    levels <- c("2021-11-15", "2021-11-16", "2021-11-17",
                "2021-11-20", "2021-11-21", "2021-11-25",
                "2021-12-05"
                )
    df$library.prep.batch <- factor(df$library.prep.batch, levels=levels)
    
    # group
    table(df$group)
    levels <- c("WT untreated", "WT ASO placebo", "WT dCas13 placebo",
                "DM1 untreated", "DM1 ASO placebo", "DM1 ASO high dose treatment", "DM1 ASO low dose treatment",
                "DM1 dCas13 placebo", "DM1 dCas13 treated"
                )
    df$group <- factor(df$group, levels=levels)

##################################################################

# Boxplot: reads.total
    # Definition
    data <- df
    x <- data$library.prep.batch
    y <- data$reads.total.pe/1e6
    maintitle <- ""
    ytitle <- "Total Reads (PE; Million)"
    xtitle <- "Library Prep. Batch"
    #xlabels <- n.cells$label
    fivenum(y) ; ymin <- 0 ; ymax <- 110 ; yinterval <- 20

    # Plot
    plot <- ggplot() +
        geom_boxplot(data, mapping=aes(x=x, y=y), fill="grey", color="black", outlier.size=1) +
        #geom_jitter(data, mapping=aes(x=x, y=y), position=position_jitter(width=0.1, height=0), size=0.001) +
        stat_summary(data, mapping=aes(x=x, y=y), geom="point", fun="mean", fill="red", col="black", size=2, shape=23) +
        #scale_x_discrete(labels=xlabels) +
        scale_y_continuous(breaks=seq(ymin, ymax, by=yinterval), limits=c(ymin, ymax)) +
        labs(title=maintitle, x=xtitle, y=ytitle) +
        theme(panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            panel.background = element_blank(),
            panel.border=element_blank(),
            plot.title=element_text(hjust = 0.5, size=12),
            plot.subtitle=element_text(hjust = 0.5, size=12),
            axis.line.y.left = element_line(color="black"),
            axis.line.x = element_line(color="black"),
            axis.title=element_text(size=12),
            axis.text.x=element_text(size=8, colour="black", angle=45, hjust=1, vjust=1),
            axis.text.y=element_text(size=10, colour="black"),
            legend.position="none"
            )
            
    # Save file
    path <- "/Users/seanwen/Documents/Hanifi/QC/Plots_By Library Batch/"
    file <- "reads.total.pdf"
    ggsave(paste(path, file, sep=""), plot, width=2.5, height=3)

# Boxplot: reads.mapped
    # Definition
    data <- df
    x <- data$library.prep.batch
    y <- data$reads.mapped.pe/1e6
    maintitle <- ""
    ytitle <- "Reads Mapped (PE; Million)"
    xtitle <- "Library Prep. Batch"
    #xlabels <- n.cells$label
    fivenum(y) ; ymin <- 0 ; ymax <- 110 ; yinterval <- 20
    
    # Plot
    plot <- ggplot() +
        geom_boxplot(data, mapping=aes(x=x, y=y), fill="grey", color="black", outlier.size=1) +
        #geom_jitter(data, mapping=aes(x=x, y=y), position=position_jitter(width=0.1, height=0), size=0.001) +
        stat_summary(data, mapping=aes(x=x, y=y), geom="point", fun="mean", fill="red", col="black", size=2, shape=23) +
        #scale_x_discrete(labels=xlabels) +
        scale_y_continuous(breaks=seq(ymin, ymax, by=yinterval), limits=c(ymin, ymax)) +
        labs(title=maintitle, x=xtitle, y=ytitle) +
        theme(panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            panel.background = element_blank(),
            panel.border=element_blank(),
            plot.title=element_text(hjust = 0.5, size=12),
            plot.subtitle=element_text(hjust = 0.5, size=12),
            axis.line.y.left = element_line(color="black"),
            axis.line.x = element_line(color="black"),
            axis.title=element_text(size=12),
            axis.text.x=element_text(size=8, colour="black", angle=45, hjust=1, vjust=1),
            axis.text.y=element_text(size=10, colour="black"),
            legend.position="none"
            )
            
    # Save file
    path <- "/Users/seanwen/Documents/Hanifi/QC/Plots_By Library Batch/"
    file <- "reads.mapped.pdf"
    ggsave(paste(path, file, sep=""), plot, width=2.5, height=3)
    
# Boxplot: pct.align
    # Definition
    data <- df
    x <- data$library.prep.batch
    y <- data$pct.align
    maintitle <- ""
    ytitle <- "Alignment Rate (%)"
    xtitle <- "Library Prep. Batch"
    #xlabels <- n.cells$label
    fivenum(y) ; ymin <- 75 ; ymax <- 100 ; yinterval <- 5

    # Plot
    plot <- ggplot() +
        geom_boxplot(data, mapping=aes(x=x, y=y), fill="grey", color="black", outlier.size=1) +
        #geom_jitter(data, mapping=aes(x=x, y=y), position=position_jitter(width=0.1, height=0), size=0.001) +
        stat_summary(data, mapping=aes(x=x, y=y), geom="point", fun="mean", fill="red", col="black", size=2, shape=23) +
        #scale_x_discrete(labels=xlabels) +
        scale_y_continuous(breaks=seq(ymin, ymax, by=yinterval), limits=c(ymin, ymax)) +
        labs(title=maintitle, x=xtitle, y=ytitle) +
        theme(panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            panel.background = element_blank(),
            panel.border=element_blank(),
            plot.title=element_text(hjust = 0.5, size=12),
            plot.subtitle=element_text(hjust = 0.5, size=12),
            axis.line.y.left = element_line(color="black"),
            axis.line.x = element_line(color="black"),
            axis.title=element_text(size=12),
            axis.text.x=element_text(size=8, colour="black", angle=45, hjust=1, vjust=1),
            axis.text.y=element_text(size=10, colour="black"),
            legend.position="none"
            )
            
    # Save file
    path <- "/Users/seanwen/Documents/Hanifi/QC/Plots_By Library Batch/"
    file <- "pct.align.pdf"
    ggsave(paste(path, file, sep=""), plot, width=2.5, height=3)

# Boxplot: pct.mt
    # Definition
    data <- df
    x <- data$library.prep.batch
    y <- data$pct.mt
    maintitle <- ""
    ytitle <- "Mitochondria Reads (%)"
    xtitle <- "Library Prep. Batch"
    #xlabels <- n.cells$label
    fivenum(y) ; ymin <- 0 ; ymax <- 3 ; yinterval <- 0.5

    # Plot
    plot <- ggplot() +
        geom_boxplot(data, mapping=aes(x=x, y=y), fill="grey", color="black", outlier.size=1) +
        #geom_jitter(data, mapping=aes(x=x, y=y), position=position_jitter(width=0.1, height=0), size=0.001) +
        stat_summary(data, mapping=aes(x=x, y=y), geom="point", fun="mean", fill="red", col="black", size=2, shape=23) +
        #scale_x_discrete(labels=xlabels) +
        scale_y_continuous(breaks=seq(ymin, ymax, by=yinterval), limits=c(ymin, ymax)) +
        labs(title=maintitle, x=xtitle, y=ytitle) +
        theme(panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            panel.background = element_blank(),
            panel.border=element_blank(),
            plot.title=element_text(hjust = 0.5, size=12),
            plot.subtitle=element_text(hjust = 0.5, size=12),
            axis.line.y.left = element_line(color="black"),
            axis.line.x = element_line(color="black"),
            axis.title=element_text(size=12),
            axis.text.x=element_text(size=8, colour="black", angle=45, hjust=1, vjust=1),
            axis.text.y=element_text(size=10, colour="black"),
            legend.position="none"
            )
            
    # Save file
    path <- "/Users/seanwen/Documents/Hanifi/QC/Plots_By Library Batch/"
    file <- "pct.mt.pdf"
    ggsave(paste(path, file, sep=""), plot, width=2.5, height=3)

# Boxplot: n.genes.detected
    # Definition
    data <- df
    x <- data$library.prep.batch
    y <- data$n.genes.detected
    maintitle <- ""
    ytitle <- "Genes Detected (n)"
    xtitle <- "Library Prep. Batch"
    #xlabels <- n.cells$label
    fivenum(y) ; ymin <- 13000 ; ymax <- 17000 ; yinterval <- 500

    # Plot
    plot <- ggplot() +
        geom_boxplot(data, mapping=aes(x=x, y=y), fill="grey", color="black", outlier.size=1) +
        #geom_jitter(data, mapping=aes(x=x, y=y), position=position_jitter(width=0.1, height=0), size=0.001) +
        stat_summary(data, mapping=aes(x=x, y=y), geom="point", fun="mean", fill="red", col="black", size=2, shape=23) +
        #scale_x_discrete(labels=xlabels) +
        scale_y_continuous(breaks=seq(ymin, ymax, by=yinterval), limits=c(ymin, ymax)) +
        labs(title=maintitle, x=xtitle, y=ytitle) +
        theme(panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            panel.background = element_blank(),
            panel.border=element_blank(),
            plot.title=element_text(hjust = 0.5, size=12),
            plot.subtitle=element_text(hjust = 0.5, size=12),
            axis.line.y.left = element_line(color="black"),
            axis.line.x = element_line(color="black"),
            axis.title=element_text(size=12),
            axis.text.x=element_text(size=8, colour="black", angle=45, hjust=1, vjust=1),
            axis.text.y=element_text(size=7, colour="black"),
            legend.position="none"
            )
            
    # Save file
    path <- "/Users/seanwen/Documents/Hanifi/QC/Plots_By Library Batch/"
    file <- "n.genes.detected.pdf"
    ggsave(paste(path, file, sep=""), plot, width=2.5, height=3)

# Boxplot: pct.duplicate
    # Definition
    data <- df
    x <- data$library.prep.batch
    y <- data$pct.duplicate
    maintitle <- ""
    ytitle <- "Duplication Rate (%)"
    xtitle <- "Library Prep. Batch"
    #xlabels <- n.cells$label
    fivenum(y) ; ymin <- 20 ; ymax <- 66 ; yinterval <- 10

    # Plot
    plot <- ggplot() +
        geom_boxplot(data, mapping=aes(x=x, y=y), fill="grey", color="black", outlier.size=1) +
        #geom_jitter(data, mapping=aes(x=x, y=y), position=position_jitter(width=0.1, height=0), size=0.001) +
        stat_summary(data, mapping=aes(x=x, y=y), geom="point", fun="mean", fill="red", col="black", size=2, shape=23) +
        #scale_x_discrete(labels=xlabels) +
        scale_y_continuous(breaks=seq(ymin, ymax, by=yinterval), limits=c(ymin, ymax)) +
        labs(title=maintitle, x=xtitle, y=ytitle) +
        theme(panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            panel.background = element_blank(),
            panel.border=element_blank(),
            plot.title=element_text(hjust = 0.5, size=12),
            plot.subtitle=element_text(hjust = 0.5, size=12),
            axis.line.y.left = element_line(color="black"),
            axis.line.x = element_line(color="black"),
            axis.title=element_text(size=12),
            axis.text.x=element_text(size=8, colour="black", angle=45, hjust=1, vjust=1),
            axis.text.y=element_text(size=10, colour="black"),
            legend.position="none"
            )
            
    # Save file
    path <- "/Users/seanwen/Documents/Hanifi/QC/Plots_By Library Batch/"
    file <- "pct.duplicate.pdf"
    ggsave(paste(path, file, sep=""), plot, width=2.5, height=3)
