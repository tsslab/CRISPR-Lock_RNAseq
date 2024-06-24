# Load packages
library(plyr)
library(ggplot2)
library(ggrepel)
library(dplyr)

# Read DE outputs
  # DM1 dCas13 placebo vs WT dCas13 placebo
  path <- "C:/Users/mhanifi/MARVEL/DE/Tables/"
  file <- "df.2.small.ASO_high.txt"
  df.ASO <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")

  # DM1 dCas13 treated vs WT dCas13 placebo
  path <- "C:/Users/mhanifi/MARVEL/DE/Tables/"
  file <- "df.2.small.dCas13.txt"
  df.dCas13 <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")

# Subset expressed DM1 events in dCas13 vs ASO
overlap <- intersect(df.ASO$tran_id, df.dCas13$tran_id)

df.ASO.small <- df.ASO[which(df.ASO$tran_id %in% overlap), c("tran_id", "gene_short_name", "reversed")]
df.dCas13.small <- df.dCas13[which(df.dCas13$tran_id %in% overlap), c("tran_id", "gene_short_name", "reversed")]

# Simplify classification in ASO group
df.ASO.small$reversed[which(df.ASO.small$reversed=="partial")] <- "yes"
df.ASO.small$reversed[which(df.ASO.small$reversed=="undefined")] <- "no"
df.ASO.small$reversed[which(df.ASO.small$reversed=="worse")] <- "no"

# Simplify classification in dCas13 group
df.dCas13.small$reversed[which(df.dCas13.small$reversed=="partial")] <- "yes"
df.dCas13.small$reversed[which(df.dCas13.small$reversed=="undefined")] <- "no"
df.dCas13.small$reversed[which(df.dCas13.small$reversed=="worse")] <- "no"

# Set factor level
levels <- intersect(c("no", "yes"), unique(df.ASO.small$reversed))
df.ASO.small$reversed <- factor(df.ASO.small$reversed, levels=levels)

levels <- intersect(c("no", "yes"), unique(df.dCas13.small$reversed))
df.dCas13.small$reversed <- factor(df.dCas13.small$reversed, levels=levels)

# Change column names
colnames(df.ASO.small)[3] <- "reversed.ASO"
colnames(df.dCas13.small)[3] <- "reversed.dCas13"

# merge data
merged.df <- merge(df.ASO.small, df.dCas13.small, by=c("tran_id", "gene_short_name"))

# make reserved.both column
merged.df$reversed.both <- "unknown"

# indicate both reversal
index <- which(merged.df$reversed.ASO=="yes" & merged.df$reversed.dCas13=="yes")
merged.df$reversed.both[index] <- "both"

# indicate none reversal
index <- which(merged.df$reversed.ASO=="no" & merged.df$reversed.dCas13=="no")
merged.df$reversed.both[index] <- "none"

# indicate only dCas13 reversal
index <- which(merged.df$reversed.ASO=="no" & merged.df$reversed.dCas13=="yes")
merged.df$reversed.both[index] <- "dCas13 only"

# indicate only ASO reversal
index <- which(merged.df$reversed.ASO=="yes" & merged.df$reversed.dCas13=="no")
merged.df$reversed.both[index] <- "ASO only"

# Set factor level
levels <- intersect(c("both", "none", "dCas13 only", "ASO only"), unique(merged.df$reversed.both))
merged.df$reversed.both <- factor(merged.df$reversed.both, levels=levels)

# merge both dataset
head(merged.df)

# save dataset
. <- merged.df
file <- "dCas13_ASO_merged_reversal.txt"
path <- paste("C:/Users/Muhammad Hanifi/Downloads/mh_plots/", "/", sep="")
write.table(., paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)