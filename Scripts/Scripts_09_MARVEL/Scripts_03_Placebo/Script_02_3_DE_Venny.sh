# Read DE outputs
    # ASO
    path <- "/Users/seanwen/Documents/Hanifi/MARVEL/DE/Tables/"
    file <- "DM1 ASO placebo vs WT ASO placebo.txt"
    df.1 <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")
    
    # dCas13
    path <- "/Users/seanwen/Documents/Hanifi/MARVEL/DE/Tables/"
    file <- "DM1 dCas13 placebo vs WT dCas13 placebo.txt"
    df.2 <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")
    
# Subset overlapping expressed events
#tran_ids.1 <- df.1$tran_id
#tran_ids.2 <- df.2$tran_id
#overlap <- intersect(tran_ids.1, tran_ids.2)
#length(tran_ids.1) ; length(tran_ids.2) ; length(overlap)

#############################################################
######################### UP IN DM1 #########################
#############################################################

# Define events
event_types <- c("SE", "MXE", "RI", "A5SS", "A3SS", "ALE", "AFE")

aso.unique <- NULL
dcas13.unique <- NULL
overlap <- NULL

aso.unique.list <- list()
dcas13.unique.list <- list()
overlap.list <- list()
    
for(i in 1:length(event_types)) {

    # ASO
    df.1.small<- df.1[which(df.1$event_type==event_types[i]), ]
    index <- which(df.1.small$p.val.adj < 0.01 & df.1.small$mean.diff > 0.15 & df.1.small$outliers==FALSE)
    df.1.small <- df.1.small[index, ]

    # dCas13
    df.2.small <- df.2[which(df.2$event_type==event_types[i]), ]
    index <- which(df.2.small$p.val.adj < 0.01 & df.2.small$mean.diff > 0.15 & df.2.small$outliers==FALSE)
    df.2.small <- df.2.small[index, ]

    # Find ASO-unique
    aso.unique[i] <- length(setdiff(df.1.small$tran_id, df.2.small$tran_id))
    
    aso.unique.tran_ids <- setdiff(df.1.small$tran_id, df.2.small$tran_id)
    aso.unique.list[[i]] <- df.1.small[which(df.1.small$tran_id %in% aso.unique.tran_ids), ]
    
    # Find dCas13-unique
    dcas13.unique[i] <- length(setdiff(df.2.small$tran_id, df.1.small$tran_id))
    
    dcas13.unique.tran_ids <- setdiff(df.2.small$tran_id, df.1.small$tran_id)
    dcas13.unique.list[[i]] <- df.2.small[which(df.2.small$tran_id %in% dcas13.unique.tran_ids), ]
        
    # ASO-dCas13 overlap
    overlap[i]  <- length(intersect(df.2.small$tran_id, df.1.small$tran_id))
    
    overlap.tran_ids <- intersect(df.2.small$tran_id, df.1.small$tran_id)
    overlap.list[[i]] <- df.1.small[which(df.1.small$tran_id %in% overlap.tran_ids), ]
    
}

# Save files
    # ASO-unique
    . <- do.call(rbind.data.frame, aso.unique.list)

    path <- "/Users/seanwen/Documents/Hanifi/MARVEL/DE/Venny/"
    file <- "ASO_Unique_Up.txt"
    write.table(., paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)

    # dCas13-unique
    . <- do.call(rbind.data.frame, dcas13.unique.list)

    path <- "/Users/seanwen/Documents/Hanifi/MARVEL/DE/Venny/"
    file <- "dCas13_Unique_Up.txt"
    write.table(., paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)
    
    
    # ASO-dCas13 overlap
    . <- do.call(rbind.data.frame, overlap.list)

    path <- "/Users/seanwen/Documents/Hanifi/MARVEL/DE/Venny/"
    file <- "ASO-dCas13_Overlap_Up.txt"
    write.table(., paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)

# Tabulate counts
results <- data.frame("event_type"=event_types,
                      "aso.unique"=aso.unique,
                      "dcas13.unique"=dcas13.unique,
                      "overlap"=overlap,
                      stringsAsFactors=FALSE
                      )


# Compute sum
. <- apply(results[-1], 2, function(x) {sum(x)})
. <- data.frame(t(.))
.. <- data.frame("event_type"="all")
. <- cbind.data.frame(.., .)
results <- rbind.data.frame(results, .)

# Save file to plot Venn Diagram
path <- "/Users/seanwen/Documents/Hanifi/MARVEL/DE/Venny/"
file <- "ASO-dCas13_Overview_Venny_Up.txt"
write.table(results, paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)

#############################################################
######################## DOWN IN DM1 ########################
#############################################################

# Define events
event_types <- c("SE", "MXE", "RI", "A5SS", "A3SS", "ALE", "AFE")

aso.unique <- NULL
dcas13.unique <- NULL
overlap <- NULL

aso.unique.list <- list()
dcas13.unique.list <- list()
overlap.list <- list()
    
for(i in 1:length(event_types)) {

    # ASO
    df.1.small<- df.1[which(df.1$event_type==event_types[i]), ]
    index <- which(df.1.small$p.val.adj < 0.01 & df.1.small$mean.diff < -0.15 & df.1.small$outliers==FALSE)
    df.1.small <- df.1.small[index, ]

    # dCas13
    df.2.small <- df.2[which(df.2$event_type==event_types[i]), ]
    index <- which(df.2.small$p.val.adj < 0.01 & df.2.small$mean.diff < -0.15 & df.2.small$outliers==FALSE)
    df.2.small <- df.2.small[index, ]

    # Find ASO-unique
    aso.unique[i] <- length(setdiff(df.1.small$tran_id, df.2.small$tran_id))
    
    aso.unique.tran_ids <- setdiff(df.1.small$tran_id, df.2.small$tran_id)
    aso.unique.list[[i]] <- df.1.small[which(df.1.small$tran_id %in% aso.unique.tran_ids), ]
    
    # Find dCas13-unique
    dcas13.unique[i] <- length(setdiff(df.2.small$tran_id, df.1.small$tran_id))
    
    dcas13.unique.tran_ids <- setdiff(df.2.small$tran_id, df.1.small$tran_id)
    dcas13.unique.list[[i]] <- df.2.small[which(df.2.small$tran_id %in% dcas13.unique.tran_ids), ]
        
    # ASO-dCas13 overlap
    overlap[i]  <- length(intersect(df.2.small$tran_id, df.1.small$tran_id))
    
    overlap.tran_ids <- intersect(df.2.small$tran_id, df.1.small$tran_id)
    overlap.list[[i]] <- df.1.small[which(df.1.small$tran_id %in% overlap.tran_ids), ]
    
}

# Save files
    # ASO-unique
    . <- do.call(rbind.data.frame, aso.unique.list)

    path <- "/Users/seanwen/Documents/Hanifi/MARVEL/DE/Venny/"
    file <- "ASO_Unique_Down.txt"
    write.table(., paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)

    # dCas13-unique
    . <- do.call(rbind.data.frame, dcas13.unique.list)

    path <- "/Users/seanwen/Documents/Hanifi/MARVEL/DE/Venny/"
    file <- "dCas13_Unique_Down.txt"
    write.table(., paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)
    
    
    # ASO-dCas13 overlap
    . <- do.call(rbind.data.frame, overlap.list)

    path <- "/Users/seanwen/Documents/Hanifi/MARVEL/DE/Venny/"
    file <- "ASO-dCas13_Overlap_Down.txt"
    write.table(., paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)

# Tabulate counts
results <- data.frame("event_type"=event_types,
                      "aso.unique"=aso.unique,
                      "dcas13.unique"=dcas13.unique,
                      "overlap"=overlap,
                      stringsAsFactors=FALSE
                      )


# Compute sum
. <- apply(results[-1], 2, function(x) {sum(x)})
. <- data.frame(t(.))
.. <- data.frame("event_type"="all")
. <- cbind.data.frame(.., .)
results <- rbind.data.frame(results, .)

# Save file to plot Venn Diagram
path <- "/Users/seanwen/Documents/Hanifi/MARVEL/DE/Venny/"
file <- "ASO-dCas13_Overview_Venny_Down.txt"
write.table(results, paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)

