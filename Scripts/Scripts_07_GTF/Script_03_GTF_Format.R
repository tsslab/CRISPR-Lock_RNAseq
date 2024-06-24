# Load CCB modules
#module load R-cbrg/202203
#R

# Load packages
library(data.table)
library(plyr)

# Read stringtie output
path <- "/project/tsslab/mhanifi/RNAseq_data/GTF/"
file <- "Merged.gtf"
df <- as.data.frame(fread(paste(path, file, sep=""), sep="\t", header=FALSE, stringsAsFactors=FALSE))

# Keep legit chromosomes
table(df$V1)
#df <- df[-grep("^GL", df$V1), ]
#df <- df[-grep("^KI", df$V1), ]
df <- df[-which(df$V1 %in% c("chrY", "chrM")), ]
table(df$V1)

# Retrieve attributes (known transcript)
    # Subset
    df.known <- df[-grep("transcript_id \"MSTRG", df$V9), ]
    table(df.known$V3)
    #df.known[grep("ENSG00000115616.2", df.known$V9),]

    # gene_id: stringtie
    . <- sapply(strsplit(df.known$V9, split=";"), function(x) {x[grep("^gene_id", x)]})
    . <- gsub("gene_id", "", .)
    . <- gsub(" ", "", .)
    . <- gsub("\"", "", .)
    head(.)
    df.known$gene_id_stringtie <- .
    
    # gene_id
    . <- sapply(strsplit(df.known$V9, split=";"), function(x) {x[grep("ENSG", x)][1]})
    . <- gsub("ref_gene_id", "", .)
    . <- gsub("gene_id", "", .)
    . <- gsub(" ", "", .)
    . <- gsub("\"", "", .)
    head(.)
    df.known$gene_id <- .
    
    # gene_name
    . <- sapply(strsplit(df.known$V9, split=";"), function(x) {x[grep("gene_name", x)]})
    . <- gsub("gene_name", "", .)
    . <- gsub(" ", "", .)
    . <- gsub("\"", "", .)
    head(.)
    df.known$gene_name <- .
    
    # transcript_id
    . <- sapply(strsplit(df.known$V9, split=";"), function(x) {x[grep("transcript_id", x)]})
    . <- gsub("transcript_id", "", .)
    . <- gsub(" ", "", .)
    . <- gsub("\"", "", .)
    head(.)
    df.known$transcript_id <- .
    
    # exon number
    . <- sapply(strsplit(df.known$V9, split=";"), function(x) {x[grep("exon_number", x)]})
    . <- gsub("exon_number", "", .)
    . <- gsub(" ", "", .)
    . <- gsub("\"", "", .)
    .[which(.=="character(0)")] <- NA
    head(.)
    df.known$exon_number <- .
    
# Annotate known transcripts with gene_type
    # Read reference file
    path <- "/project/tsslab/mhanifi/genome_reference/GRCh38_Transcriptome_GENCODE/"
    file <- "gencode.v31.annotation.gtf"
    gencode <- as.data.frame(fread(paste(path, file, sep=""), sep="\t", header=FALSE, stringsAsFactors=FALSE))
    
    # Subset genes
    gencode <- gencode[which(gencode$V3=="gene"), ]

    # Subset gene_id
    . <- sapply(strsplit(gencode$V9, split=";"), function(x) {x[1]})
    . <- gsub("gene_id", "", .)
    . <- gsub(" ", "", .)
    . <- gsub("\"", "", .)
    head(.)
    gencode$gene_id <- .

    # Subset gene_type
    . <- sapply(strsplit(gencode$V9, split=";"), function(x) {x[2]})
    . <- gsub("gene_type", "", .)
    . <- gsub(" ", "", .)
    . <- gsub("\"", "", .)
    head(.)
    gencode$gene_type <- .
    
    # Annotate
    df.known <- join(df.known, unique(gencode[,c("gene_id", "gene_type")]), by="gene_id", type="left")

# Retrieve attributes (novel transcript)
    # Subset
    df.novel <- df[grep("transcript_id \"MSTRG", df$V9), ]
    table(df.novel$V3)
    
    # gene_id: stringtie
    . <- sapply(strsplit(df.novel$V9, split=";"), function(x) {x[1]})
    . <- gsub("gene_id", "", .)
    . <- gsub(" ", "", .)
    . <- gsub("\"", "", .)
    head(.)
    df.novel$gene_id_stringtie <- .
    
    # transcript_id
    . <- sapply(strsplit(df.novel$V9, split=";"), function(x) {x[2]})
    . <- gsub("transcript_id", "", .)
    . <- gsub(" ", "", .)
    . <- gsub("\"", "", .)
    head(.)
    df.novel$transcript_id <- .
    
    # exon num
    . <- sapply(strsplit(df.novel$V9, split=";"), function(x) {x[3]})
    . <- gsub("exon_number", "", .)
    . <- gsub(" ", "", .)
    . <- gsub("\"", "", .)
    .[grep("gene_name", .)] <- NA
    head(.)
    df.novel$exon_number <- .

# Subset protein-coding novel transcripts
    # Read reference file
    path <- "/project/tsslab/mhanifi/genome_reference/GRCh38_Transcriptome_GENCODE/"
    file <- "gencode.v31.annotation.gtf"
    gencode <- as.data.frame(fread(paste(path, file, sep=""), sep="\t", header=FALSE, stringsAsFactors=FALSE))
    
    # Subset genes
    gencode <- gencode[which(gencode$V3=="gene"), ]

    # Subset gene_id
    . <- sapply(strsplit(gencode$V9, split=";"), function(x) {x[1]})
    . <- gsub("gene_id", "", .)
    . <- gsub(" ", "", .)
    . <- gsub("\"", "", .)
    head(.)
    gencode$gene_id <- .

    # Subset gene_type
    . <- sapply(strsplit(gencode$V9, split=";"), function(x) {x[2]})
    . <- gsub("gene_type", "", .)
    . <- gsub(" ", "", .)
    . <- gsub("\"", "", .)
    head(.)
    gencode$gene_type <- .
    
    # Subset protein-coding genes
    gencode <- unique(gencode[which(gencode$gene_type=="protein_coding"), c("gene_id", "gene_type")])
    
    # Create reference data frame for known gene ids
    ref <- df.known[, c("gene_id_stringtie", "gene_id", "gene_name")]
    ref <- unique(ref)
    
    # Check for duplicates
    tbl <- as.data.frame(table(ref$gene_id_stringtie))
    table(tbl$Freq)
    
    # Subset protein-coding genes
    ref <- join(ref, gencode, by="gene_id", type="left")
    ref <- ref[!is.na(ref$gene_type), ]
    
    # Check for duplicates
    tbl <- as.data.frame(table(ref$gene_id_stringtie))
    table(tbl$Freq)
    
    # Remove duplicates
    dup <- unique(as.character(tbl[which(tbl$Freq != 1), 1]))
    ref <- ref[-which(ref$gene_id_stringtie %in% dup), ]
    
    # Annotate novel transcripts
    df.novel <- join(df.novel, ref, by="gene_id_stringtie", type="left")
    df.novel <- df.novel[!is.na(df.novel$gene_id), ]
    table(df.novel$V3)
    
# Format
    # Reorder columns
    col.order <- c("V1", "V2", "V3", "V4", "V5", "V6", "V7", "V8",
                   "gene_id", "gene_name", "gene_type", "transcript_id")
    df.known <- df.known[, col.order]
    df.novel <- df.novel[, col.order]
    
    # Merge
    df <- rbind.data.frame(df.known, df.novel)
    
    # Create attribute column
    df$attr <- paste("gene_id \"", df$gene_id, "\"", "; " , "gene_name \"", df$gene_name, "\"", "; ", "gene_type \"", df$gene_type, "\"", "; ", "transcript_id \"", df$transcript_id, "\"", "; ", sep="")

# Create gene entries
gene_ids <- unique(df$gene_id)

df.list <- list()

pb <- txtProgressBar(1, length(gene_ids), style=3)

for(i in 1:length(gene_ids)) {

    # Subset
    . <- df[which(df$gene_id==gene_ids[i]), ]
    
    # Create full attributes
    attr <- paste("gene_id \"", .$gene_id[1], "\"", "; " ,
                  "gene_status \"KNOWN\"; ",
                  "gene_name \"", .$gene_name[1], "\"", ";",
                  "gene_type \"", .$gene_type[1], "\"", ";",
                  sep="")
    
    # Format gene row
    gene <- .[1 ,c(1:12)]
    gene$V3 <- "gene"
    gene$attr <- attr
    
    # Merge
    df.list[[i]] <- rbind.data.frame(gene, .)
    
    # Track progress
    setTxtProgressBar(pb, i)
    
}

df.final <- do.call(rbind.data.frame, df.list)

# Remove intermediate columns
df.final$gene_id <- NULL
df.final$gene_name <- NULL
df.final$gene_type <- NULL
df.final$transcript_id <- NULL

# Write file
path <- "/project/tsslab/mhanifi/RNAseq_data/GTF/"
file <- "BRIE_Formatted.gtf"
write.table(df.final, paste(path, file, sep=""), sep="\t", col.names=FALSE, row.names=FALSE, quote=FALSE)

