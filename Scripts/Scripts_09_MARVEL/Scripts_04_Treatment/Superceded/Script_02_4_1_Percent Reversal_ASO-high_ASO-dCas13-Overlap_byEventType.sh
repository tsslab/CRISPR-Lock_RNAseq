# Load packages
library(plyr)
library(ggplot2)
library(ggrepel)

# Read DE outputs
    # DM1 placebo vs WT placebo, ASO-dCas13 overlap
        # Up
        path <- "/Users/seanwen/Documents/Hanifi/MARVEL/DE/Venny/"
        file <- "ASO-dCas13_Overlap_Up.txt"
        df.1.1 <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")
    
        # Down
        path <- "/Users/seanwen/Documents/Hanifi/MARVEL/DE/Venny/"
        file <- "ASO-dCas13_Overlap_Down.txt"
        df.1.2 <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")
        
        # Merge
        df.1 <- rbind.data.frame(df.1.1, df.1.2)
    
    # DM1 ASO-high treated vs WT ASO placebo
    path <- "/Users/seanwen/Documents/Hanifi/MARVEL/DE/Tables/"
    file <- "DM1 ASO high dose treatment vs WT ASO placebo.txt"
    df.2 <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")

# Read positive controls
path <- "/Users/seanwen/Documents/Hanifi/Positive Controls/"
file <- "SE_featureData.txt"
df.feature.se <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")

# Define event types
event_types <- c("SE", "MXE", "RI", "A5SS", "A3SS", "AFE", "ALE")

for(i in 1:length(event_types)) {

    # Subset DM1 events, event type
    index.1 <- which(df.1$p.val.adj < 0.01 & abs(df.1$mean.diff) > 0.15 & df.1$outliers==FALSE)
    index.2 <- which(df.1$event_type==event_types[i])
    index <- intersect(index.1, index.2)
    
    df.1.small <- df.1[index, ]
    
    # Subset expressed DM1 events in treated vs placebo
    overlap <- intersect(df.1.small$tran_id, df.2$tran_id)
    
    . <- data.frame("comparison"=c("DM1 placebo vs WT placebo, ASO-dCas13 overlap", "DM1 ASO high dose treatment vs WT ASO placebo (Overlap with above)"), "n.events"=c(length(df.1.small$tran_id), length(overlap)), stringsAsFactors=FALSE)
    
    path <- paste("/Users/seanwen/Documents/Hanifi/MARVEL/Pct Reversal/ASO-high_ASO-dCas13-Overlap/", event_types[i], "/", sep="")
    file <- "DM1 Events N Overlap.txt"
    write.table(., paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)

    df.1.small <- df.1.small[which(df.1.small$tran_id %in% overlap), ]
    df.2.small <- df.2[which(df.2$tran_id %in% overlap), ]
    
    # Indicate reversal
    index <- abs(df.2.small$mean.diff) < 0.15
    sum(index)
    df.2.small$reversed <- ifelse(index, "yes", "no/partial")
    df.2.small$reversed <- factor(df.2.small$reversed, levels=c("no/partial", "yes"))
    
    ###############################################################
    ######################## SCATTERPLOT ##########################
    ###############################################################
    
    # Scatterplot: DM1 ASO placebo vs WT ASO placebo
        # Definition
        data <- df.1.small
        x <- data$mean.g1
        y <- data$mean.g2
        maintitle <- ""
        xtitle <- "WT ASO placebo"
        ytitle <- "DM1 ASO-high placebo"
        
        xmin <- 0 ; xmax <- 1 ; xinterval <- 0.25
        ymin <- 0 ; ymax <- 1 ; yinterval <- 0.25
        
        # Plot
        plot <- ggplot() +
            geom_point(data, mapping=aes(x=x, y=y), fill="black", size=0.5, alpha=0.5) +
            geom_abline(intercept=c(-0.15, 0.15), size=0.25, linetype="dashed", color="red") +
            #geom_text_repel(data, mapping=aes(x=x, y=y, label=label), max.overlaps = Inf, box.padding = 1.0, size=2, max.time = 1, max.iter = 1e5, segment.alpha=0.5, segment.size=0.1, min.segment.length = 0) +
            scale_x_continuous(breaks=seq(xmin, xmax, by=xinterval), limits=c(xmin, xmax)) +
            scale_y_continuous(breaks=seq(ymin, ymax, by=yinterval), limits=c(ymin, ymax)) +
            scale_fill_manual(values=colors) +
            labs(title=maintitle, x=xtitle, y=ytitle) +
            theme(panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank(),
                  panel.background = element_blank(),
                  panel.border=element_blank(),
                  plot.title=element_text(size=10, hjust=0.5),
                  axis.line=element_line(colour = "black"),
                  axis.title=element_text(size=10),
                  axis.text=element_text(size=8, colour="black")
                  )
        
        # Save plot
        path <- paste("/Users/seanwen/Documents/Hanifi/MARVEL/Pct Reversal/ASO-high_ASO-dCas13-Overlap/", event_types[i], "/", sep="")
        file <- "DM1 ASO placebo vs WT ASO placebo.pdf"
        ggsave(paste(path, file, sep=""), plot, width=2.5, height=2.5)
        
    if(event_types[i]=="SE") {
    
        # Scatterplot: DM1 ASO placebo vs WT ASO placebo, +ve ctrls annotated
            # Retrieve tran_ids
            gene_short_names <- c("MBNL1", "MBNL2", "DMD")
            tran_ids <- df.feature.se[which(df.feature.se$gene_short_name %in% gene_short_names), "tran_id"]
            
            # Create labels
            df.1.small$labels <- ifelse(df.1.small$tran_id %in% tran_ids, df.1.small$gene_short_name, "")
        
            # Definition
            data <- df.1.small
            x <- data$mean.g1
            y <- data$mean.g2
            maintitle <- ""
            xtitle <- "WT ASO placebo"
            ytitle <- "DM1 ASO-high placebo"
            labels <- df.1.small$labels
            
            xmin <- 0 ; xmax <- 1 ; xinterval <- 0.25
            ymin <- 0 ; ymax <- 1 ; yinterval <- 0.25
            
            # Plot
            plot <- ggplot() +
                geom_point(data, mapping=aes(x=x, y=y), fill="black", size=0.5, alpha=0.5) +
                geom_abline(intercept=c(-0.15, 0.15), size=0.25, linetype="dashed", color="red") +
                geom_text_repel(data, mapping=aes(x=x, y=y, label=labels), max.overlaps = Inf, box.padding = 1.0, size=2, max.time = 1, max.iter = 1e5, segment.alpha=1.0, segment.size=0.25, min.segment.length = 0, color="red") +
                scale_x_continuous(breaks=seq(xmin, xmax, by=xinterval), limits=c(xmin, xmax)) +
                scale_y_continuous(breaks=seq(ymin, ymax, by=yinterval), limits=c(ymin, ymax)) +
                scale_fill_manual(values=colors) +
                labs(title=maintitle, x=xtitle, y=ytitle) +
                theme(panel.grid.major = element_blank(),
                      panel.grid.minor = element_blank(),
                      panel.background = element_blank(),
                      panel.border=element_blank(),
                      plot.title=element_text(size=10, hjust=0.5),
                      axis.line=element_line(colour = "black"),
                      axis.title=element_text(size=10),
                      axis.text=element_text(size=8, colour="black")
                      )
            
            # Save plot
            path <- paste("/Users/seanwen/Documents/Hanifi/MARVEL/Pct Reversal/ASO-high_ASO-dCas13-Overlap/", event_types[i], "/", sep="")
            file <- "DM1 ASO placebo vs WT ASO placebo_Positive Controls Annotated.pdf"
            ggsave(paste(path, file, sep=""), plot, width=5, height=5)

    }

    # Scatterplot: DM1 ASO high dose treatment vs WT ASO placebo
        # Definition
        data <- df.2.small
        x <- data$mean.g1
        y <- data$mean.g2
        z <- data$reversed
        maintitle <- ""
        xtitle <- "WT ASO placebo"
        ytitle <- "DM1 ASO-high placebo"
        legendtitle <- "PSI Reversed"
        
        xmin <- 0 ; xmax <- 1 ; xinterval <- 0.25
        ymin <- 0 ; ymax <- 1 ; yinterval <- 0.25
        
        # Plot
        plot <- ggplot() +
            geom_point(data, mapping=aes(x=x, y=y, color=z), size=0.5, alpha=0.5) +
            geom_abline(intercept=c(-0.15, 0.15), size=0.25, linetype="dashed", color="red") +
            scale_color_manual(values=c("orange", "blue")) +
            #geom_text_repel(data, mapping=aes(x=x, y=y, label=label), max.overlaps = Inf, box.padding = 1.0, size=2, max.time = 1, max.iter = 1e5, segment.alpha=0.5, segment.size=0.1, min.segment.length = 0) +
            scale_x_continuous(breaks=seq(xmin, xmax, by=xinterval), limits=c(xmin, xmax)) +
            scale_y_continuous(breaks=seq(ymin, ymax, by=yinterval), limits=c(ymin, ymax)) +
            labs(title=maintitle, x=xtitle, y=ytitle, color=legendtitle) +
            theme(panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank(),
                  panel.background = element_blank(),
                  panel.border=element_blank(),
                  plot.title=element_text(size=10, hjust=0.5),
                  axis.line=element_line(colour = "black"),
                  axis.title=element_text(size=10),
                  axis.text=element_text(size=8, colour="black"),
                  legend.title=element_text(size=8),
                  legend.text=element_text(size=8),
                  legend.key = element_blank()
                  ) +
            guides(color = guide_legend(override.aes=list(size=2)))
        
        # Save plot
        path <- paste("/Users/seanwen/Documents/Hanifi/MARVEL/Pct Reversal/ASO-high_ASO-dCas13-Overlap/", event_types[i], "/", sep="")
        file <- "DM1 ASO high dose treatment vs WT ASO placebo.pdf"
        ggsave(paste(path, file, sep=""), plot, width=3.5, height=2.5)

    if(event_types[i]=="SE") {
    
        # Scatterplot: DM1 ASO high dose treatment vs WT ASO placebo, +ve ctrls annotated
            # Retrieve tran_ids
            gene_short_names <- c("MBNL1", "MBNL2", "DMD")
            tran_ids <- df.feature.se[which(df.feature.se$gene_short_name %in% gene_short_names), "tran_id"]
            
            # Create labels
            df.2.small$labels <- ifelse(df.2.small$tran_id %in% tran_ids, df.2.small$gene_short_name, "")
            
            # Definition
            data <- df.2.small
            x <- data$mean.g1
            y <- data$mean.g2
            z <- data$reversed
            maintitle <- ""
            xtitle <- "WT ASO placebo"
            ytitle <- "DM1 ASO-high placebo"
            legendtitle <- "PSI Reversed"
            
            xmin <- 0 ; xmax <- 1 ; xinterval <- 0.25
            ymin <- 0 ; ymax <- 1 ; yinterval <- 0.25
            
            # Plot
            plot <- ggplot() +
                geom_point(data, mapping=aes(x=x, y=y, color=z), size=0.5, alpha=0.5) +
                geom_abline(intercept=c(-0.15, 0.15), size=0.25, linetype="dashed", color="red") +
                scale_color_manual(values=c("orange", "blue")) +
                geom_text_repel(data, mapping=aes(x=x, y=y, label=labels), max.overlaps = Inf, box.padding = 1.0, size=2, max.time = 1, max.iter = 1e5, segment.alpha=1.0, segment.size=0.25, min.segment.length = 0, color="red") +
                scale_x_continuous(breaks=seq(xmin, xmax, by=xinterval), limits=c(xmin, xmax)) +
                scale_y_continuous(breaks=seq(ymin, ymax, by=yinterval), limits=c(ymin, ymax)) +
                labs(title=maintitle, x=xtitle, y=ytitle, color=legendtitle) +
                theme(panel.grid.major = element_blank(),
                      panel.grid.minor = element_blank(),
                      panel.background = element_blank(),
                      panel.border=element_blank(),
                      plot.title=element_text(size=10, hjust=0.5),
                      axis.line=element_line(colour = "black"),
                      axis.title=element_text(size=10),
                      axis.text=element_text(size=8, colour="black"),
                      legend.title=element_text(size=8),
                      legend.text=element_text(size=8),
                      legend.key = element_blank()
                      ) +
                guides(color = guide_legend(override.aes=list(size=2)))
            
            # Save plot
            path <- paste("/Users/seanwen/Documents/Hanifi/MARVEL/Pct Reversal/ASO-high_ASO-dCas13-Overlap/", event_types[i], "/", sep="")
            file <- "DM1 ASO high dose treatment vs WT ASO placebo_Positive Controls Annotated.pdf"
            ggsave(paste(path, file, sep=""), plot, width=5, height=5)

    }

    ###############################################################
    ########################## PIECHART ###########################
    ###############################################################
    
    # Compute proportions
    . <- as.data.frame(table(df.2.small$reversed), stringsAsFactors=FALSE)
    names(.) <- c("reversed", "freq")
    .$pct <- .$freq / sum(.$freq) * 100
    
    # Set factor levels
    .$reversed <- factor(.$reversed, levels=c("yes", "no/partial"))
    . <- .[order(.$reversed), ]

    # Plot
        # Compute statistics for plot
        .$fraction <- .$freq / sum(.$freq)
        .$ymax <- cumsum(.$fraction)
        .$ymin = c(0, .$ymax[-length(.$ymax)])
        
        # Definitions
        data <- .
        xmax <- nrow(data) + 1
        xmin <- nrow(data)
        ymax <- data$ymax
        ymin <- data$ymin
        z <- data$reversed
        maintitle <- ""
        xtitle <- ""
        ytitle <- ""
        legendtitle <- "PSI Reversed"
        
        # Plot
        plot <- ggplot() +
            geom_rect(data=data, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=z), color="black") +
            coord_polar(theta="y") +
            xlim(c(2, 4)) +
            scale_fill_manual(values=c("blue", "orange")) +
            labs(title=maintitle, x=xtitle, y=ytitle, fill=legendtitle) +
            theme(panel.grid.major = element_blank(),
                panel.grid.minor = element_blank(),
                panel.background = element_blank(),
                panel.border=element_blank(),
                plot.title=element_text(hjust = 0.5, size=15),
                plot.subtitle=element_text(hjust = 0.5, size=15),
                axis.line = element_blank(),
                axis.ticks=element_blank(),
                axis.text=element_blank(),
                legend.title=element_text(size=8),
                legend.text=element_text(size=8)
                )
        
        # Save plot
        path <- paste("/Users/seanwen/Documents/Hanifi/MARVEL/Pct Reversal/ASO-high_ASO-dCas13-Overlap/", event_types[i], "/", sep="")
        file <- "Percent Reversal.pdf"
        ggsave(paste(path, file, sep=""), plot, width=2.5, height=2.5)

    # Save file
    path <- paste("/Users/seanwen/Documents/Hanifi/MARVEL/Pct Reversal/ASO-high_ASO-dCas13-Overlap/", event_types[i], "/", sep="")
    file <- "Percent Reversal.txt"
    write.table(., paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)

    ###############################################################

    df.1.small$labels <- NULL
    df.2.small$labels <- NULL
    
    # Save overlapping events
        # Save
        path <- paste("/Users/seanwen/Documents/Hanifi/MARVEL/Pct Reversal/ASO-high_ASO-dCas13-Overlap/", event_types[i], "/", sep="")
        file <- "DM1 ASO placebo vs WT ASO placebo.txt"
        write.table(df.1.small, paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)

        # DM1 ASO high dose treatment vs WT ASO placebo
        path <- paste("/Users/seanwen/Documents/Hanifi/MARVEL/Pct Reversal/ASO-high_ASO-dCas13-Overlap/", event_types[i], "/", sep="")
        file <- "DM1 ASO high dose treatment vs WT ASO placebo.txt"
        write.table(df.2.small, paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)
        
    # Track progress
    print(paste(event_types[i], " done", sep=""))

}
