# Load packages
library(MARVEL)
library(plyr)
library(pheatmap)

# Load R object
path <- "/Users/seanwen/Documents/Hanifi/MARVEL/R Object/"
file <- "MARVEL.RData"
load(file=paste(path, file, sep=""))

# Define sig splicing sets
sets <- c("ASO_Unique", "dCas13_Unique", "ASO-dCas13_Overlap")

.list.go <- list()

for(j in 1:length(sets)) {

    # Read Venny tables
    path <- "/Users/seanwen/Documents/Hanifi/MARVEL/DE/Venny/"
    files <- list.files(path)
    files <- grep(sets[j], files, fixed=TRUE, value=TRUE)
    
    .list <- list()
    
    for(i in 1:length(files)) {
    
        file <- files[i]
        .list[[i]] <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")
    
    }
    
    df <- do.call(rbind.data.frame, .list)
    
    # Subset specific event type
    df <- df[which(df$event_type=="A3SS"), ]

    # Retrieve gene names
    gene_short_names <- unique(df$gene_short_name)
    
    # GO
    marvel <- BioPathways(MarvelObject=marvel,
                          method.adjust="fdr",
                          custom.genes=gene_short_names,
                          species="human"
                          )
    
    results <- marvel$DE$BioPathways$Table
        
    # Save into list
    .list.go[[j]] <- results
    
    # Save file
    path <- "/Users/seanwen/Documents/Hanifi/MARVEL/DE/GO/"
    file <- paste("A3SS_", sets[j], ".txt", sep="")
    write.table(results, paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)
    
    # Track progress
    print(paste(sets[j], " done", sep=""))

}

names(.list.go) <- c("ASO-Unique", "dCas13-Unique", "Overlap")

# Save as new object
df.list <- .list.go

#######################################################################
####################### HEATMAP: ALL COMPARISONS ######################
#######################################################################

# Tabulate padj
. <- lapply(df.list, function(x) {(x[,c("Description", "p.adjust")])})
names(.[[1]])[2] <- names(df.list)[[1]]
names(.[[2]])[2] <- names(df.list)[[2]]
names(.[[3]])[2] <- names(df.list)[[3]]
#names(.[[4]])[2] <- names(.list)[[4]]
#names(.[[5]])[2] <- names(.list)[[5]]
#names(.[[6]])[2] <- labels[6]
#names(.[[7]])[2] <- labels[7]
#names(.[[8]])[2] <- labels[8]
#names(.[[9]])[2] <- labels[9]
. <- Reduce(function(x,y) join(x=x, y=y, by="Description", type="full"), .)
row.names(.) <- .$Description
.$Description <- NULL
padj <- .

# Censor non-sig
threshold <- 0.05
padj[padj > threshold] <- NA

# Remove non-sig in all comparisons
. <- apply(padj, 1, function(x) {sum(!is.na(x)) != 0})
padj <- padj[.,]

# Transform values
padj <- -log10(padj)

# Reorder by n sig pathways across all comparisons
n <- apply(padj, 1, function(x) {sum(!is.na(x))})
n <- sort(n, decreasing=TRUE)
padj <- padj[names(n), ]

# Plot and save
data <- padj

path <- "/Users/seanwen/Documents/Hanifi/MARVEL/DE/GO/"
file <- "A3SS_Heatmap.pdf"
pdf(paste(path, file, sep=""), width=4, height=6)
 
pheatmap(data, cluster_rows=FALSE, cluster_cols=FALSE, scale="none", fontsize_row=5, border_color="white", legend=FALSE, color="red", angle_col=90)

dev.off()
