# Transfer metadata from local to server
scp -rp '/Users/seanwen/Documents/Hanifi/Metadata/RNAseq Metadata_SeanEdit.xlsx' mhanifi@cbrglogin1.molbiol.ox.ac.uk:/project/tsslab/mhanifi/RNAseq_data/Metadata/

#####################################################################################
module load R-cbrg/202201

R

#####################################################################################

# Load packages
library(plyr)
library(ggplot2)
library(data.table)
library(gdata)

# Disable scientific notation
options(scipen=999)

###################################################################################

# Tabulate total reads
path <- "/project/tsslab/mhanifi/RNAseq_data/QC/Total_Reads/"
files <- list.files(path)

reads.total.pe <- NULL

pb <- txtProgressBar(1, length(files), style=3)

for(i in 1:length(files)) {

    . <- read.table(paste(path, files[i], sep=""), sep="\t", header=FALSE, stringsAsFactors=FALSE, quote="\"")
    . <- grep("Total reads processed", .$V1, fixed=TRUE, value=TRUE)
    . <- trimws(gsub("Total reads processed:", "", .))
    . <- as.numeric(gsub(",", "", .))
    reads.total.pe[i] <- .
    
    # Track progress
    setTxtProgressBar(pb, i)
    
}

reads.total.pe <- data.frame("file.name"=files, "reads.total.pe"=reads.total.pe, stringsAsFactors=FALSE)

reads.total.pe$file.name <- gsub("_trimming_report.txt", "", reads.total.pe$file.name, fixed=TRUE)

# Match FASTQ file name to sample id
    # Read metadata
    path <- "/project/tsslab/mhanifi/RNAseq_data/Metadata/"
    file <- "RNAseq Metadata_SeanEdit.xlsx"
    md <- read.xls(paste(path, file, sep=""), sheet=1, header=TRUE, stringsAsFactors=FALSE)

    # Match
    reads.total.pe <- join(reads.total.pe, md[,c("file.name", "sample.id")], by="file.name", type="left")
    
    # Keep relevant columns
    reads.total.pe <- reads.total.pe[,c("sample.id", "reads.total.pe")]

# Tabulate mapped reads
path <- "/project/tsslab/mhanifi/RNAseq_data/QC/Mapped_Reads/"
files <- list.files(path)

reads.mapped.pe <- NULL
reads.mapped <- NULL

pb <- txtProgressBar(1, length(files), style=3)

for(i in 1:length(files)) {

    . <- read.table(paste(path, files[i], sep=""), sep="\t", header=FALSE, stringsAsFactors=FALSE, fill=TRUE)
    reads.mapped.pe[i] <- as.numeric(.[grep("reads mapped and paired:", .$V2, fixed=TRUE), 3]) / 2
    reads.mapped[i] <- as.numeric(.[grep("reads mapped:", .$V2, fixed=TRUE), 3, 3])
    
    # Track progress
    setTxtProgressBar(pb, i)

}

reads.mapped <- data.frame("sample.id"=files, "reads.mapped.pe"=reads.mapped.pe, "reads.mapped"=reads.mapped, stringsAsFactors=FALSE)

reads.mapped$sample.id <- gsub(".txt", "", reads.mapped$sample.id, fixed=TRUE)

# Tabulate mito reads
path <- "/project/tsslab/mhanifi/RNAseq_data/QC/MT/"
files <- list.files(path)

reads.mt <- NULL

pb <- txtProgressBar(1, length(files), style=3)

for(i in 1:length(files)) {

    . <- read.table(paste(path, files[i], sep=""), sep="\t", header=FALSE, stringsAsFactors=FALSE)
    . <- .[1,1]
    reads.mt[i] <- .
    
    # Track progress
    setTxtProgressBar(pb, i)
    
}

reads.mt <- data.frame("sample.id"=files, "reads.mt"=reads.mt, stringsAsFactors=FALSE)

reads.mt$sample.id <- gsub(".txt", "", reads.mt$sample.id, fixed=TRUE)

# Tabulate duplication rate
path <- "/project/tsslab/mhanifi/RNAseq_data/QC/DupMetric/"
files <- list.files(path)

.list <- list()

for(i in 1:length(files)) {

    .list[[i]] <- read.table(paste(path, files[i], sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, nrows=1)
    
}

dup <- do.call(rbind.data.frame, .list)

dup$sample.id <- gsub(".Aligned.sortedByCoord_DupMarked.metrics.txt", "", files, fixed=TRUE)
dup <- dup[,c("sample.id", "PERCENT_DUPLICATION")]
names(dup)[2] <- "pct.duplicate"
dup$pct.duplicate <- dup$pct.duplicate * 100

#######################################################################

# Merge
df <- join(reads.total.pe, reads.mapped, by="sample.id", type="left")
df <- join(df, reads.mt, by="sample.id", type="left")
df <- join(df, dup, by="sample.id", type="left")

# Compute % MT
df$pct.mt <- df$reads.mt / df$reads.mapped * 100

# Compute % align
df$pct.align <- df$reads.mapped.pe / df$reads.total.pe * 100

# Reorder columns
cols <- c("sample.id", "reads.total.pe", "reads.mapped.pe", "pct.align",
          "reads.mapped", "reads.mt", "pct.mt", "pct.duplicate")
df <- df[, cols]

# Save file
path <- "/project/tsslab/mhanifi/RNAseq_data/QC/"
file <- "QC.txt"
write.table(df, paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)

################################################################################

scp -rp mhanifi@cbrglogin1.molbiol.ox.ac.uk:/project/tsslab/mhanifi/RNAseq_data/QC/QC.txt /Users/seanwen/Documents/Hanifi/QC/
