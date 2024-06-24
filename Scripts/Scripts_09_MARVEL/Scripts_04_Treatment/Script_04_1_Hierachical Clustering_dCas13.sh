# Load packages
library(data.table)
library(plyr)
library(MARVEL)
library(pheatmap)
library(RColorBrewer)

# Load MARVEL object
path <- "/Users/seanwen/Documents/Hanifi/MARVEL/R Object/"
file <- "MARVEL.RData"
load(file=paste(path, file, sep=""))

# Retrieve PSI matrix
df <- do.call(rbind.data.frame, marvel$PSI)
row.names(df) <- df$tran_id
df$tran_id <- NULL

# Define events
event_types <- c("SE", "MXE", "RI", "A5SS", "A3SS", "AFE", "ALE")

######################################################################
######################### INDIVIDUAL SAMPLES #########################
######################################################################

for(i in 1:length(event_types)) {
   
    # Subset DE events
        # Read DE output, reversed annotated file
        path <- paste("/Users/seanwen/Documents/Hanifi/MARVEL/Pct Reversal/dCas13/", event_types[i], "/", sep="")
        file <- "DM1 dCas13 treated vs WT dCas13 placebo.txt"
        de <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")
    
        # Subset
        df.small <- df[de$tran_id, ]
    
    # Define sample groups
        # Retrieve phenoData
        df.pheno <- marvel$SplicePheno
        
        # Retrieve sample groups
        df.col <- data.frame("sample.id"=names(df.small), stringsAsFactors=FALSE)
        df.col <- join(df.col, df.pheno[,c("sample.id", "group")], by="sample.id", type="left")
        row.names(df.col) <- df.col$sample.id
        df.col$sample.id <- NULL
    
        # Set factor levels
        table(df.col$group)
        levels <- c("WT dCas13 placebo",
                    "DM1 dCas13 placebo",
                    "DM1 dCas13 treated"
                    )

        df.col$group <- factor(df.col$group, levels=levels)
        df.col <- na.omit(df.col)
    
    # Subset sample groups
    df.small <- df.small[, row.names(df.col)]
    
    # Remove events with missing values
    #df.small <- na.omit(df.small)
    
    # Heatmap
    path <- paste("/Users/seanwen/Documents/Hanifi/MARVEL/Pct Reversal/dCas13/", event_types[i], "/", sep="")
    file <- "Hierarchical Clustering_Individual Samples.pdf"
    pdf(paste(path, file, sep=""), width=4, height=3)
    
    pheatmap(df.small,
             scale="row", col=rev(brewer.pal(10,"RdBu")), border_color=NA,
             cluster_cols=TRUE, cluster_rows=TRUE,
             clustering_distance_cols="maximum", clustering_distance_rows="maximum",
             clustering_method="median",
             treeheight_col=10, treeheight_row=0,
             annotation_col=df.col,
             show_colnames=FALSE, show_rownames=FALSE
             )
             
    dev.off()
             
    # Track progress
    print(event_types[i])

}

######################################################################
########################## COLLAPSE BY GROUP #########################
######################################################################

for(i in 1:length(event_types)) {
   
    # Subset DE events
        # Read DE output, reversed annotated file
        path <- paste("/Users/seanwen/Documents/Hanifi/MARVEL/Pct Reversal/dCas13/", event_types[i], "/", sep="")
        file <- "DM1 dCas13 treated vs WT dCas13 placebo.txt"
        de <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")
    
        # Subset
        df.small <- df[de$tran_id, ]
    
    # Define sample groups
        # Retrieve phenoData
        df.pheno <- marvel$SplicePheno
        
        # Retrieve sample groups
        df.col <- data.frame("sample.id"=names(df.small), stringsAsFactors=FALSE)
        df.col <- join(df.col, df.pheno[,c("sample.id", "group")], by="sample.id", type="left")
        row.names(df.col) <- df.col$sample.id
        df.col$sample.id <- NULL
    
        # Set factor levels
        table(df.col$group)
        levels <- c("WT dCas13 placebo",
                    "DM1 dCas13 placebo",
                    "DM1 dCas13 treated"
                    )

        df.col$group <- factor(df.col$group, levels=levels)
        df.col <- na.omit(df.col)
    
    # Subset sample groups
    df.small <- df.small[, row.names(df.col)]
    
    # Collapse by mean
    groups <- levels(df.col$group)
    
    .list <- list()
    
    for(j in 1:length(groups)) {
    
        sample.ids <- row.names(df.col[which(df.col$group==groups[j]), , drop=FALSE])
        df.small. <- df.small[, sample.ids]
        . <- apply(df.small., 1, function(x) {mean(x)})
        . <- data.frame(.)
        names(.) <- groups[j]
        .list[[j]] <- .
        
    }
    
    df.small <- do.call(cbind.data.frame, .list)
    
    # Remove events with missing values
    #df.small <- na.omit(df.small)
    
    # Heatmap
    path <- paste("/Users/seanwen/Documents/Hanifi/MARVEL/Pct Reversal/dCas13/", event_types[i], "/", sep="")
    file <- "Hierarchical Clustering_Collapsed by Group.pdf"
    pdf(paste(path, file, sep=""), width=1.5, height=3)
    
    pheatmap(df.small,
             scale="row", col=rev(brewer.pal(10,"RdBu")), border_color=NA,
             cluster_cols=TRUE, cluster_rows=TRUE,
             clustering_distance_cols="euclidean", clustering_distance_rows="euclidean",
             clustering_method="complete",
             treeheight_col=10, treeheight_row=0,
             #annotation_col=df.col,
             show_colnames=TRUE, show_rownames=FALSE,
             angle_col=90
             )
    
    dev.off()
    
}

######################################################################
################### INDIVIDUAL SAMPLES: ALL EVENT TYPES ##############
######################################################################

# Subset DE events
.list <- list()

for(i in 1:length(event_types)) {
    
    # Read DE output, reversed annotated file
    path <- paste("/Users/seanwen/Documents/Hanifi/MARVEL/Pct Reversal/dCas13/", event_types[i], "/", sep="")
    file <- "DM1 dCas13 treated vs WT dCas13 placebo.txt"
    .list[[i]] <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")
        
}

de <- do.call(rbind.data.frame, .list)

df.small <- df[de$tran_id, ]
    
# Define sample groups
    # Retrieve phenoData
    df.pheno <- marvel$SplicePheno
    
    # Retrieve sample groups
    df.col <- data.frame("sample.id"=names(df.small), stringsAsFactors=FALSE)
    df.col <- join(df.col, df.pheno[,c("sample.id", "group")], by="sample.id", type="left")
    row.names(df.col) <- df.col$sample.id
    df.col$sample.id <- NULL

    # Set factor levels
    table(df.col$group)
    levels <- c("WT dCas13 placebo",
                "DM1 dCas13 placebo",
                "DM1 dCas13 treated"
                )

    df.col$group <- factor(df.col$group, levels=levels)
    df.col <- na.omit(df.col)

# Subset sample groups
df.small <- df.small[, row.names(df.col)]

# Remove events with missing values
#df.small <- na.omit(df.small)

# Heatmap
path <- paste("/Users/seanwen/Documents/Hanifi/MARVEL/Pct Reversal/dCas13/", "All", "/", sep="")
file <- "Hierarchical Clustering_Individual Samples.pdf"
pdf(paste(path, file, sep=""), width=4, height=3)

pheatmap(df.small,
         scale="row", col=rev(brewer.pal(10,"RdBu")), border_color=NA,
         cluster_cols=TRUE, cluster_rows=TRUE,
         clustering_distance_cols="maximum", clustering_distance_rows="maximum",
         clustering_method="median",
         treeheight_col=10, treeheight_row=0,
         annotation_col=df.col,
         show_colnames=FALSE, show_rownames=FALSE
         )
         
dev.off()

######################################################################
#################### COLLAPSE BY GROUP: ALL EVENT TYPES ##############
######################################################################

# Subset DE events
.list <- list()

for(i in 1:length(event_types)) {
    
    # Read DE output, reversed annotated file
    path <- paste("/Users/seanwen/Documents/Hanifi/MARVEL/Pct Reversal/dCas13/", event_types[i], "/", sep="")
    file <- "DM1 dCas13 treated vs WT dCas13 placebo.txt"
    .list[[i]] <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")
        
}

de <- do.call(rbind.data.frame, .list)

df.small <- df[de$tran_id, ]

# Define sample groups
    # Retrieve phenoData
    df.pheno <- marvel$SplicePheno
    
    # Retrieve sample groups
    df.col <- data.frame("sample.id"=names(df.small), stringsAsFactors=FALSE)
    df.col <- join(df.col, df.pheno[,c("sample.id", "group")], by="sample.id", type="left")
    row.names(df.col) <- df.col$sample.id
    df.col$sample.id <- NULL

    # Set factor levels
    table(df.col$group)
    levels <- c("WT dCas13 placebo",
                "DM1 dCas13 placebo",
                "DM1 dCas13 treated"
                )

    df.col$group <- factor(df.col$group, levels=levels)
    df.col <- na.omit(df.col)

# Subset sample groups
df.small <- df.small[, row.names(df.col)]

# Collapse by mean
groups <- levels(df.col$group)

.list <- list()

for(j in 1:length(groups)) {

    sample.ids <- row.names(df.col[which(df.col$group==groups[j]), , drop=FALSE])
    df.small. <- df.small[, sample.ids]
    . <- apply(df.small., 1, function(x) {mean(x)})
    . <- data.frame(.)
    names(.) <- groups[j]
    .list[[j]] <- .
    
}

df.small <- do.call(cbind.data.frame, .list)

# Remove events with missing values
#df.small <- na.omit(df.small)

# Heatmap
path <- paste("/Users/seanwen/Documents/Hanifi/MARVEL/Pct Reversal/dCas13/", "All", "/", sep="")
file <- "Hierarchical Clustering_Collapsed by Group.pdf"
pdf(paste(path, file, sep=""), width=1.5, height=3)

pheatmap(df.small,
         scale="row", col=rev(brewer.pal(10,"RdBu")), border_color=NA,
         cluster_cols=TRUE, cluster_rows=TRUE,
         clustering_distance_cols="maximum", clustering_distance_rows="maximum",
         clustering_method="median",
         treeheight_col=10, treeheight_row=0,
         #annotation_col=df.col,
         show_colnames=TRUE, show_rownames=FALSE,
         angle_col=90
         )

dev.off()
