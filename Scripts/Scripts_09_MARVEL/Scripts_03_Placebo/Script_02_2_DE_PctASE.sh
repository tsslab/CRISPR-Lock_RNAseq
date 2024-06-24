# Load packages
library(MARVEL)
library(reshape2)
library(plyr)
library(ggplot2)

# Define comparison groups
    # Retrieve files
    path <- "/Users/seanwen/Documents/Hanifi/MARVEL/DE/Tables/"
    files <- list.files(path)
    
    # Retrieve ref group
    . <- strsplit(files, split=" vs ", fixed=TRUE)
    . <- sapply(., function(x) {x[2]})
    . <- gsub(".txt", "", ., fixed=TRUE)
    ref <- .
    
    # Retrieve ref group
    . <- strsplit(files, split=" vs ", fixed=TRUE)
    . <- sapply(., function(x) {x[1]})
    . <- gsub("DE_", "", ., fixed=TRUE)
    non.ref <- .

# Load MARVEL object
path <- "/Users/seanwen/Documents/Hanifi/MARVEL/R Object/"
file <- "MARVEL.RData"
load(file=paste(path, file, sep=""))

##################################################################
########################### PERCENTAGE ###########################
##################################################################

for(i in 1:length(non.ref)) {

    # Read DE table
    path <- "/Users/seanwen/Documents/Hanifi/MARVEL/DE/Tables/"
    file <- paste(non.ref[i], " vs ", ref[i], ".txt", sep="")
    df <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")
    
    # Insert DE table into DE slot
    marvel$DE$PSI$Table[["permutation"]] <- df
    
    # Tabulate % ASE
    marvel <- PctASE(MarvelObject=marvel,
                     method="permutation",
                     psi.pval=0.01,
                     psi.mean.diff=0.15,
                     ylabels.size=10,
                     barlabels.size=2.5,
                     x.offset=0,
                     mode="percentage"
                     )

    # Save plot
    path <- "/Users/seanwen/Documents/Hanifi/MARVEL/DE/Barchart/"
    file <- paste(non.ref[i], " vs ", ref[i], "_Percentage.pdf", sep="")
    ggsave(paste(path, file, sep=""), marvel$DE$PctASE$Plot, width=6, height=3)
    
    # Save file
    path <- "/Users/seanwen/Documents/Hanifi/MARVEL/DE/Barchart/"
    file <- paste(non.ref[i], " vs ", ref[i], "_Percentage.txt", sep="")
    write.table(marvel$DE$PctASE$Table, paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)
    
}

##################################################################
######################## ABSOLUTE NUMBER #########################
##################################################################

for(i in 1:length(non.ref)) {

    # Read DE table
    path <- "/Users/seanwen/Documents/Hanifi/MARVEL/DE/Tables/"
    file <- paste(non.ref[i], " vs ", ref[i], ".txt", sep="")
    df <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")
    
    # Insert DE table into DE slot
    marvel$DE$PSI$Table[["permutation"]] <- df
    
    # Tabulate % ASE
    marvel <- PctASE(MarvelObject=marvel,
                     method="permutation",
                     psi.pval=0.01,
                     psi.mean.diff=0.15,
                     ylabels.size=10,
                     barlabels.size=2.5,
                     x.offset=50,
                     mode="absolute"
                     )

    # Save plot
    path <- "/Users/seanwen/Documents/Hanifi/MARVEL/DE/Barchart/"
    file <- paste(non.ref[i], " vs ", ref[i], "_Absolute.pdf", sep="")
    ggsave(paste(path, file, sep=""), marvel$DE$AbsASE$Plot, width=6, height=3)
    
    # Save file
    path <- "/Users/seanwen/Documents/Hanifi/MARVEL/DE/Barchart/"
    file <- paste(non.ref[i], " vs ", ref[i], "_Absolute.txt", sep="")
    write.table(marvel$DE$AbsASE$Table, paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)
    
}
