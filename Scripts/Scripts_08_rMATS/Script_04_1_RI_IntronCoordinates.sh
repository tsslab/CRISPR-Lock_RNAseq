# Load packages
library(data.table)
library(plyr)

# Read all events
path <- "/Users/seanwen/Documents/Hanifi/rMATS/ASEvents/"
file <- "fromGTF.RI.txt"
df <- as.data.frame(fread(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE))

# Remove novel events (artifacts)
#path <- "/Users/seanwen/Documents/Hanifi/rMATS/ASEvents/"
#file <- "fromGTF.novelJunction.RI.txt"
#df.novel <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE)
#df <- df[-which(df$ID %in% df.novel$ID), ]

# Subset intron coordinates: +ve strand
    # Subset
    . <- df[which(df$strand=="+"), ]
    
    # Convert coordinates to reflect exon
    #.$riExonStart_0base <- .$riExonStart_0base + 1
    #.$downstreamES <- .$downstreamES + 1

    # Subset coordinates
    . <- .[,c("chr", "upstreamEE", "downstreamES")]
    
    # Convert coordinates to reflect intron
    .$upstreamEE <- .$upstreamEE + 1
    
    # Save as new object
    df.pos <- .
                       
# Create tran_id: -ve strand
    # Subset
    . <- df[which(df$strand=="-"), ]
    
    # Convert coordinates to reflect exon
    #.$riExonStart_0base <- .$riExonStart_0base + 1
    #.$downstreamES <- .$downstreamES + 1

    # Subset coordinates
    . <- .[,c("chr", "upstreamEE", "downstreamES")]
    
    # Convert coordinates to reflect intron
    .$upstreamEE <- .$upstreamEE + 1
    # Save as new object
    df.neg <- .
                       
# Merge
df <- rbind.data.frame(df.pos, df.neg)

# Remove exon coordinates
#df$upstreamEE <- df$upstreamEE + 1
#df$downstreamES <- df$downstreamES - 1

# Reorder
table(df$chr)
df$chr <- factor(df$chr,
                levels=c("chr1", "chr2", "chr3", "chr4", "chr5",
                         "chr6", "chr7", "chr8", "chr9", "chr10",
                         "chr11", "chr12", "chr13", "chr14", "chr15",
                         "chr16", "chr17", "chr18", "chr19", "chr20",
                         "chr21", "chr22", "chrX"
                          ))
df <- df[order(df$chr, df$upstreamEE),]

# Check coordinates
table(df$downstreamES > df$upstreamEE)

# Keep unique entries
df <- unique(df)

# Format for CountReads
    # Create unique intron id
    intron.ids <- paste(df$chr, df$upstreamEE, df$downstreamES, sep=":")
    df$intron.id <- intron.ids
    
    # Format columms
    cols <- c("intron.id", "chr", "upstreamEE", "downstreamES")
    df <- df[,cols]
    names(df)[which(names(df)=="upstreamEE")] <- "start"
    names(df)[which(names(df)=="downstreamES")] <- "end"

# Save file
path <- "/Users/seanwen/Documents/Hanifi/rMATS/ASEvents_MARVEL_Formatted/RI/"
file <- "RI_Coordinates.bed"
write.table(df, paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)

####################################################

# Transfer from local to server
scp -rp /Users/seanwen/Documents/Hanifi/rMATS/ASEvents_MARVEL_Formatted/RI/RI_Coordinates.bed mhanifi@cbrglogin1.molbiol.ox.ac.uk:/project/tsslab/mhanifi/RNAseq_data/rMATS/RI/
