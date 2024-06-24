# Load packages
library(plyr)
library(ggplot2)

#####################################################################
################ ASO, dCas13, and ASO-dCas13-Overlap ################
#####################################################################

# Define event type, sig splicing event sets
event_types <- c("SE", "MXE", "RI", "A5SS", "A3SS", "AFE", "ALE")
sets <- c("ASO", "dCas13", "ASO-dCas13_Overlap")

for(j in 1:length(event_types)) {

    path <- "/Users/seanwen/Documents/Hanifi/MARVEL/DE/GO/"
    files <- list.files(path)
    files <- grep(paste("^", event_types[j], sep=""), files, value=TRUE)
    
    n.terms <- NULL
            
    for(i in 1:length(sets)) {
    
        # Read GO file
        file <- grep(paste(sets[i], ".txt$", sep=""), files, value=TRUE)
        df <- tryCatch(read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA"), error=function(err) "Error")
        
        if(class(df)=="data.frame") {
                                
            # Tabulate n sig. GO terms
            threshold <- 0.01
            n.terms[i] <- sum(df$p.adjust < threshold)
            
        } else {
        
            n.terms[i] <- 0
        
        }
        
    }
    
    results <- data.frame("event_type"=event_types[j],
                          "set"=sets,
                          "n.terms"=n.terms,
                          stringsAsFactors=FALSE
                          )
    
    .list[[j]] <- results
    
}
    
results <- do.call(rbind.data.frame, .list)

# Set factor levels
results$event_type <- factor(results$event_type, levels=rev(event_types))
results$set <- factor(results$set, levels=rev(sets))

# Barplot
    # Definition
    data <- results
    x <- data$event_type
    y <- data$n.terms
    y2 <- data$n.terms
    z <- data$set
    maintitle <- ""
    xtitle <- ""
    ytitle <- "Significant GO Terms (n)"
    legendtitle <- "DE Splicing Set"

    #ymin <- 0 ; ymax <- max(y) + x.offset
    
    # Plot
    plot <- ggplot() +
        geom_bar(data=data, aes(x=x, y=y, fill=z), stat="identity", color="black", position=position_dodge(), width=0.8) +
        geom_text(data=data, mapping=aes(x=x, y=y, fill=z, label=y2, group=z), position=position_dodge(width=1.0), vjust=0.5, hjust=-0.25, size=3) +
        #scale_fill_manual(values=cols) +
        #scale_y_continuous(limits=c(ymin, ymax)) +
        #scale_x_discrete(labels=xlabels) +
        labs(title=maintitle, x=xtitle, y=ytitle, fill=legendtitle) +
        theme(panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            panel.background = element_blank(),
            panel.border=element_blank(),
            plot.title=element_text(hjust = 0.5, size=12),
            plot.subtitle=element_text(hjust = 0.5, size=12),
            axis.line.y.left = element_line(color="black"),
            axis.line.x = element_line(color="black"),
            axis.title=element_text(size=12),
            axis.text=element_text(size=12),
            axis.text.x=element_text(size=10, colour="black"),
            axis.text.y=element_text(size=10, colour="black"),
            legend.title=element_text(size=8),
            legend.text=element_text(size=8)
            ) +
        coord_flip()

    # Save plot
    path <- "/Users/seanwen/Documents/Hanifi/MARVEL/DE/GO/"
    file <- "Summary_N Sig Terms_ASO_dCas13_ASO-dCas13-Overlap.pdf"
    ggsave(paste(path, file, sep=""), plot, width=7, height=3)

#####################################################################
########################## ASO, dCas13 ##############################
#####################################################################

# Define event type, sig splicing event sets
event_types <- c("SE", "MXE", "RI", "A5SS", "A3SS", "AFE", "ALE")
sets <- c("ASO", "dCas13")

for(j in 1:length(event_types)) {

    path <- "/Users/seanwen/Documents/Hanifi/MARVEL/DE/GO/"
    files <- list.files(path)
    files <- grep(paste("^", event_types[j], sep=""), files, value=TRUE)
    
    n.terms <- NULL
            
    for(i in 1:length(sets)) {
    
        # Read GO file
        file <- grep(paste(sets[i], ".txt$", sep=""), files, value=TRUE)
        df <- tryCatch(read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA"), error=function(err) "Error")
        
        if(class(df)=="data.frame") {
                                
            # Tabulate n sig. GO terms
            threshold <- 0.01
            n.terms[i] <- sum(df$p.adjust < threshold)
            
        } else {
        
            n.terms[i] <- 0
        
        }
        
    }
    
    results <- data.frame("event_type"=event_types[j],
                          "set"=sets,
                          "n.terms"=n.terms,
                          stringsAsFactors=FALSE
                          )
    
    .list[[j]] <- results
    
}
    
results <- do.call(rbind.data.frame, .list)

# Set factor levels
results$event_type <- factor(results$event_type, levels=rev(event_types))
results$set <- factor(results$set, levels=rev(sets))

# Barplot
    # Definition
    data <- results
    x <- data$event_type
    y <- data$n.terms
    y2 <- data$n.terms
    z <- data$set
    maintitle <- ""
    xtitle <- ""
    ytitle <- "Significant GO Terms (n)"
    legendtitle <- "DE Splicing Set"

    ymin <- 0 ; ymax <- max(y) + 5
    
    # Plot
    plot <- ggplot() +
        geom_bar(data=data, aes(x=x, y=y, fill=z), stat="identity", color="black", position=position_dodge(), width=0.8) +
        geom_text(data=data, mapping=aes(x=x, y=y, fill=z, label=y2), position=position_dodge(width=1.05), vjust=0.25, hjust=-0.25, size=3) +
        #scale_fill_manual(values=cols) +
        scale_y_continuous(limits=c(ymin, ymax)) +
        #scale_x_discrete(labels=xlabels) +
        labs(title=maintitle, x=xtitle, y=ytitle, fill=legendtitle) +
        theme(panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            panel.background = element_blank(),
            panel.border=element_blank(),
            plot.title=element_text(hjust = 0.5, size=12),
            plot.subtitle=element_text(hjust = 0.5, size=12),
            axis.line.y.left = element_line(color="black"),
            axis.line.x = element_line(color="black"),
            axis.title=element_text(size=12),
            axis.text=element_text(size=12),
            axis.text.x=element_text(size=10, colour="black"),
            axis.text.y=element_text(size=10, colour="black"),
            legend.title=element_text(size=8),
            legend.text=element_text(size=8)
            ) +
        coord_flip()

    # Save plot
    path <- "/Users/seanwen/Documents/Hanifi/MARVEL/DE/GO/"
    file <- "Summary_N Sig Terms_ASO_dCas13.pdf"
    ggsave(paste(path, file, sep=""), plot, width=6, height=3)

