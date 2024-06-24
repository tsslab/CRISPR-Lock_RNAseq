# Load packages
library(data.table)
library(plyr)
library(MARVEL)
library(ggplot2)

# Load MARVEL object
path <- "/Users/seanwen/Documents/Hanifi/MARVEL/R Object/"
file <- "MARVEL.RData"
load(file=paste(path, file, sep=""))

# Check group names
df.pheno <- marvel$SplicePheno
table(df.pheno$group)

# Read +ve ctrls
path <- "/Users/seanwen/Documents/Hanifi/Positive Controls/"
file <- "SE_featureData.txt"
df.feature.se <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")

#################################################################################
################ DM1 ASO high dose treatment vs WT ASO placebo ##################
#################################################################################

# DE
marvel <- CompareValues(MarvelObject=marvel,
                        cell.type.columns.1=c("group"),
                        cell.type.variables.1=list("WT ASO placebo"),
                        cell.type.columns.2=c("group"),
                        cell.type.variables.2=list("DM1 ASO high dose treatment"),
                        min.cells=3,
                        method=c("permutation"),
                        n.permutations=1000,
                        method.adjust="fdr",
                        level="splicing",
                        event.type=c("SE", "MXE", "RI", "A5SS", "A3SS", "ALE", "AFE"),
                        annotate.outliers=FALSE,
                        assign.modality=FALSE
                        )

results <- marvel$DE$PSI$Table[["permutation"]]
head(results)

# Check +ve ctrls
gene_short_names <- c("MBNL1", "MBNL2", "DMD")
tran_ids <- df.feature.se[which(df.feature.se$gene_short_name %in% gene_short_names), "tran_id"]
results[which(results$tran_id %in% tran_ids), ]

# Save file
path <- "/Users/seanwen/Documents/Hanifi/MARVEL/DE/Tables/"
file <- "DM1 ASO high dose treatment vs WT ASO placebo.txt"
write.table(marvel$DE$PSI$Table[["permutation"]], paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)

#################################################################################
################ DM1 ASO high dose treatment vs DM1 ASO placebo ##################
#################################################################################

# DE
marvel <- CompareValues(MarvelObject=marvel,
                        cell.type.columns.1=c("group"),
                        cell.type.variables.1=list("DM1 ASO placebo"),
                        cell.type.columns.2=c("group"),
                        cell.type.variables.2=list("DM1 ASO high dose treatment"),
                        min.cells=3,
                        method=c("permutation"),
                        n.permutations=1000,
                        method.adjust="fdr",
                        level="splicing",
                        event.type=c("SE", "MXE", "RI", "A5SS", "A3SS", "ALE", "AFE"),
                        annotate.outliers=FALSE,
                        assign.modality=FALSE
                        )

results <- marvel$DE$PSI$Table[["permutation"]]
head(results)

# Check +ve ctrls
gene_short_names <- c("MBNL1", "MBNL2", "DMD")
tran_ids <- df.feature.se[which(df.feature.se$gene_short_name %in% gene_short_names), "tran_id"]
results[which(results$tran_id %in% tran_ids), ]

# Save file
path <- "/Users/seanwen/Documents/Hanifi/MARVEL/DE/Tables/"
file <- "DM1 ASO high dose treatment vs DM1 ASO placebo.txt"
write.table(marvel$DE$PSI$Table[["permutation"]], paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)
