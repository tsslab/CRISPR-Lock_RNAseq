# Read exon coordinate file
path <- "/Users/seanwen/Documents/Hanifi/Metadata/"
file <- "List of reversed splicing events (RT-PCR confirmed)_SeanEdit.txt"
df <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE)

################################################################
########################## +VE STRAND ##########################
################################################################

# Subset events
df.pos <- df[grep(":+@", df$tran_id, fixed=TRUE), , drop=FALSE]

# Retrieve coordinates
. <- strsplit(df.pos$tran_id, split=":+@", fixed=TRUE)

# Subset chr
exon.1 <- sapply(., function(x) {x[1]})
chr <- sapply(strsplit(exon.1, ":"), function(x) {x[1]})

# Subset 5' included sj
exon.1 <- sapply(., function(x) {x[1]})
exon.2 <- sapply(., function(x) {x[2]})
start <- as.numeric(sapply(strsplit(exon.1, ":"), function(x) {x[3]})) + 1
end <- as.numeric(sapply(strsplit(exon.2, ":"), function(x) {x[2]})) - 1
coord.included.1 <- paste(chr, start, end, sep=":")

# Subset 3' included sj
exon.2 <- sapply(., function(x) {x[2]})
exon.3 <- sapply(., function(x) {x[3]})
start <- as.numeric(sapply(strsplit(exon.2, ":"), function(x) {x[3]})) + 1
end <- as.numeric(sapply(strsplit(exon.3, ":"), function(x) {x[2]})) - 1
coord.included.2 <- paste(chr, start, end, sep=":")

# Subset skipped sj
exon.1 <- sapply(., function(x) {x[1]})
exon.3 <- sapply(., function(x) {x[3]})
start <- as.numeric(sapply(strsplit(exon.1, ":"), function(x) {x[3]})) + 1
end <- as.numeric(sapply(strsplit(exon.3, ":"), function(x) {x[2]})) - 1
coord.excluded <- paste(chr, start, end, sep=":")

# Merge
coord <- c(coord.included.1, coord.included.2, coord.excluded)

# Retrieve coordinates
. <- strsplit(coord, split=":", fixed=TRUE)
chr <- sapply(., function(x) {x[1]})
start <- sapply(., function(x) {x[2]})
end <- sapply(., function(x) {x[3]})

# Format for STAR
coord.df <- data.frame("chr"=chr,
                       "start"=start,
                       "end"=end,
                       "strand"="+",
                       stringsAsFactors=FALSE
                       )
                       
# Save as new object
coord.df.pos <- coord.df
    
################################################################
########################## +VE STRAND ##########################
################################################################

# Subset events
df.neg <- df[grep(":-@", df$tran_id, fixed=TRUE), , drop=FALSE]

# Retrieve coordinates
. <- strsplit(df.neg$tran_id, split=":-@", fixed=TRUE)

# Subset chr
exon.1 <- sapply(., function(x) {x[1]})
chr <- sapply(strsplit(exon.1, ":"), function(x) {x[1]})

# Subset 5' included sj
exon.3 <- sapply(., function(x) {x[3]})
exon.2 <- sapply(., function(x) {x[2]})
start <- as.numeric(sapply(strsplit(exon.3, ":"), function(x) {x[3]})) + 1
end <- as.numeric(sapply(strsplit(exon.2, ":"), function(x) {x[2]})) - 1
coord.included.1 <- paste(chr, start, end, sep=":")

# Subset 3' included sj
exon.2 <- sapply(., function(x) {x[2]})
exon.1 <- sapply(., function(x) {x[1]})
start <- as.numeric(sapply(strsplit(exon.2, ":"), function(x) {x[3]})) + 1
end <- as.numeric(sapply(strsplit(exon.1, ":"), function(x) {x[2]})) - 1
coord.included.2 <- paste(chr, start, end, sep=":")

# Subset skipped sj
exon.3 <- sapply(., function(x) {x[3]})
exon.1 <- sapply(., function(x) {x[1]})
start <- as.numeric(sapply(strsplit(exon.3, ":"), function(x) {x[3]})) + 1
end <- as.numeric(sapply(strsplit(exon.1, ":"), function(x) {x[2]})) - 1
coord.excluded <- paste(chr, start, end, sep=":")

# Merge
coord <- c(coord.included.1, coord.included.2, coord.excluded)

# Retrieve coordinates
. <- strsplit(coord, split=":", fixed=TRUE)
chr <- sapply(., function(x) {x[1]})
start <- sapply(., function(x) {x[2]})
end <- sapply(., function(x) {x[3]})

# Format for STAR
coord.df <- data.frame("chr"=chr,
                       "start"=start,
                       "end"=end,
                       "strand"="-",
                       stringsAsFactors=FALSE
                       )
                       
# Save as new object
coord.df.neg <- coord.df

################################################################

# Merge
df <- rbind.data.frame(coord.df.pos, coord.df.neg)

# Save file
path <- "/Users/seanwen/Documents/Hanifi/Positive Controls/"
file <- "sj.txt"
write.table(df, paste(path, file, sep=""), sep="\t", col.names=FALSE, row.names=FALSE, quote=FALSE)

################################################################

scp -rp '/Users/seanwen/Documents/Hanifi/Positive Controls/sj.txt' mhanifi@cbrglogin1.molbiol.ox.ac.uk:/project/tsslab/mhanifi/RNAseq_data/Metadata/
