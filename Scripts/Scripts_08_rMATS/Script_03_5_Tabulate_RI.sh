# Load packages
library(data.table)
library(plyr)

# Tabulate events
    # Read all events
    path <- "/Users/seanwen/Documents/Hanifi/rMATS/ASEvents/"
    file <- "fromGTF.RI.txt"
    df <- as.data.frame(fread(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE))
    
    # Remove novel events (artifacts)
    #path <- "/Users/seanwen/Documents/Hanifi/rMATS/ASEvents/"
    #file <- "fromGTF.novelJunction.RI.txt"
    #df.novel <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE)
    #df <- df[-which(df$ID %in% df.novel$ID), ]
    
    # Create tran_id: +ve strand
        # Subset
        . <- df[which(df$strand=="+"), ]
        
        # Convert coordinates to reflect exon
        .$riExonStart_0base <- .$riExonStart_0base + 1
        .$downstreamES <- .$downstreamES + 1
        
        # Create tran_od
        .$tran_id <- paste(.$chr, ":", .$riExonStart_0base, ":", .$upstreamEE, ":+@",
                           .$chr, ":", .$downstreamES, ":", .$riExonEnd,
                           sep=""
                           )
                           
        # Save as new object
        df.pos <- .
                           
    # Create tran_id: -ve strand
        # Subset
        . <- df[which(df$strand=="-"), ]
        
        # Convert coordinates to reflect exon
        .$riExonStart_0base <- .$riExonStart_0base + 1
        .$downstreamES <- .$downstreamES + 1
        
        # Create tran_od
        .$tran_id <- paste(.$chr, ":", .$riExonEnd, ":", .$downstreamES, ":-@",
                           .$chr, ":", .$upstreamEE, ":", .$riExonStart_0base,
                           sep=""
                           )
                           
        # Save as new object
        df.neg <- .
                           
    # Merge
    df <- rbind.data.frame(df.pos, df.neg)
    
    # Subset relavent columns
    df <- df[, c("tran_id", "GeneID", "geneSymbol")]
    names(df)[c(2:3)] <- c("gene_id", "gene_short_name")
    
    # Keep unique entries
    df <- unique(df)

# Annotate with gene_type
    # Read GTF
    path <- "/Users/seanwen/Documents/U2AF1_2019/GTF/"
    file <- "gencode.v31.annotation.gtf"
    gtf <- as.data.frame(fread(paste(path, file, sep=""), sep="\t", header=FALSE, stringsAsFactors=FALSE, quote=""))
    
    # Build gene reference table
        # Subset genes
        ref <- gtf[which(gtf$V3=="gene"), ]
        
        # Subset selected attributes
            # gene_id
            gene_id <- strsplit(ref$V9, split=";")
            gene_id <- sapply(gene_id, function(x) grep("gene_id", x, value=TRUE))
            gene_id <- gsub("gene_id", "", gene_id)
            gene_id <- gsub(" ", "", gene_id)
            gene_id <- gsub("\"", "", gene_id)
            head(gene_id)
            
            # gene_type
            gene_type <- strsplit(ref$V9, split=";")
            gene_type <- sapply(gene_type, function(x) grep("gene_type", x, value=TRUE))
            gene_type <- gsub("gene_type", "", gene_type)
            gene_type <- gsub(" ", "", gene_type)
            gene_type <- gsub("\"", "", gene_type)
            head(gene_type)

            # Create new columns
            ref$gene_id <- gene_id
            ref$gene_type <- gene_type

            # Keep unique entries
            ref <- unique(ref[, c("gene_id", "gene_type")])
            
    # Annotate with attributes
    df <- join(df, ref, by="gene_id", type="left")

# Collapse duplicate entries
    # Tabulate freq
    . <- as.data.frame(table(df$tran_id))
    names(.) <- c("tran_id", "freq")
    tran_id.unique <- as.character(.[which(.$freq == 1), "tran_id"])
    tran_id.dup <- as.character(.[which(.$freq > 1), "tran_id"])
    
    if(length(tran_id.dup) != 0) {

        # Split data frame
        df.unique <- df[which(df$tran_id %in% tran_id.unique), ]
        df.dup <- df[which(df$tran_id %in% tran_id.dup), ]
        
        # Collapse duplicates
        tran_ids <- unique(df.dup$tran_id)
        
        .list <- list()
        
        for(i in 1:length(tran_ids)) {
        
            . <- df.dup[which(df.dup$tran_id == tran_ids[i]), ]
            .list[[i]] <- data.frame("tran_id"=tran_ids[i],
                                     "gene_id"=paste(.$gene_id, collapse="|"),
                                     "gene_short_name"=paste(.$gene_short_name, collapse="|"),
                                     "gene_type"=paste(.$gene_type, collapse="|"),
                                     stringsAsFactors=FALSE
                                     )
                                     
        }
        
        df.dup <- do.call(rbind.data.frame, .list)
        
        # Merge
        df <- rbind.data.frame(df.unique, df.dup)
        
    }
    
# Save file
path <- "/Users/seanwen/Documents/Hanifi/rMATS/ASEvents_MARVEL_Formatted/RI/"
file <- "RI_featureData.txt"
write.table(df, paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)
