module load R-base/4.0.1
module load R-cbrg/202109
R

#################################################################################

# Load packages
library(reshape2)
library(gdata)
library(plyr)

# Retrieve file names for SJ tabulation
    # Read metadata
    path <- "/project/tsslab/mhanifi/RNAseq_data/Metadata/"
    file <- "RNAseq Metadata_SeanEdit.xlsx"
    md <- read.xls(paste(path, file, sep=""), sheet=3, header=TRUE, stringsAsFactors=FALSE)

    # Retrieve samples ids
    sample.ids <- md$sample.id

    # Append file names
    files <- paste(sample.ids, ".SJ.out.tab", sep="")

# Tabulate SJ
path <- "/project/tsslab/mhanifi/RNAseq_data/SJ/"

df.list <- list()

pb <- txtProgressBar(1, length(files), style=3)

for(i in 1:length(files)) {
    
    # Check if file is empty
    error.check <- try(read.table(paste(path, files[i], sep=""), sep="\t", header=FALSE, stringsAsFactors=FALSE, na.strings="NA"), silent=TRUE)
    
    if(class(error.check)=="try-error") {
        
        df.list[[i]] <- NULL
        
    } else {
        
        # Read file
        df <- read.table(paste(path, files[19], sep=""), sep="\t", header=FALSE, stringsAsFactors=FALSE, na.strings="NA")
        
        # Merge coordinates
        df$coord.intron <- paste(df$V1, df$V2, df$V3, sep=":")

        # Annotate sample name
        df$sample.id <- strsplit(files[i], split="\\.")[[1]][1]
        
        # Rename coverage column
        names(df)[7] <- "coverage"
        
        # Reorder columns
        df <- df[,c("coord.intron", "sample.id", "coverage")]

        # Save into list
        df.list[[i]] <- df

        # Track progress
        setTxtProgressBar(pb, i)
        #print(i)
        
    }

}

# Collapse into data frame
lapply(df.list, dim)
df <- do.call(rbind.data.frame, df.list)
df <- dcast(data=df, formula=coord.intron ~ sample.id, value.var="coverage")

# Write file
path <- "/project/tsslab/mhanifi/RNAseq_data/"
file <- "SJ.txt"
write.table(df, paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)

#################################################################################

# Transfer from server to local
scp -rp mhanifi@cbrglogin1.molbiol.ox.ac.uk:/project/tsslab/mhanifi/RNAseq_data/SJ.txt /Users/seanwen/Documents/Hanifi/SJ/
