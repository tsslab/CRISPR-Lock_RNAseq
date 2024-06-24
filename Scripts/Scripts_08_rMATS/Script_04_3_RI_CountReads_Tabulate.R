# Load modules
module load R-base/4.0.1
module load R-cbrg/202109
R

# Define counts files
path <- "/project/tsslab/mhanifi/RNAseq_data/rMATS/RI/counts_individual_samples/"
files <- list.files(path)

.list <- list()

pb <- txtProgressBar(1, length(files), style=3)

for(i in 1:length(files)) {
    
    # Read and save into list
    .list[[i]] <- read.table(paste(path, files[i], sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, row.names=1)
    
    # Track progress
    setTxtProgressBar(pb, i)
    
}

df <- do.call(cbind.data.frame, .list)

# Create column for peak id
. <- data.frame("coord.intron"=row.names(df), stringsAsFactors=FALSE)
df <- cbind.data.frame(., df)
row.names(df) <- NULL

# Save file
path <- "/project/tsslab/mhanifi/RNAseq_data/rMATS/RI/"
file <- "Counts_by_Region.txt"
write.table(df, paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)


#################################################################################

scp -rp mhanifi@cbrglogin1.molbiol.ox.ac.uk:/project/tsslab/mhanifi/RNAseq_data/rMATS/RI/Counts_by_Region.txt /Users/seanwen/Documents/Hanifi/MARVEL/PSI/RI/
