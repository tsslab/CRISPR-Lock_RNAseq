# Load packages
library(MARVEL)

# Define event types
event_types <- c("SE", "MXE", "RI", "A5SS", "A3SS", "AFE", "ALE")


# Read file
path <- "C:/Users/mhanifi/MARVEL/DE/Tables/"
file <- "df.2.small.dCas13.txt"
df <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")

####################################################################
################## GO ON REVERSED BY dCas13 only ###################
####################################################################

# Define gene names
gene_short_names <- unique(df[which(df$reversed.both=="dCas13 only"), "gene_short_name"])

# GO
marvel <- list()

marvel <- BioPathways(MarvelObject=marvel,
                      method.adjust="fdr",
                      custom.genes=gene_short_names,
                      species="human"
                      )

results <- marvel$DE$BioPathways$Table

# Save file
path <- paste("C:/Users/Muhammad Hanifi/Downloads/mh_plots/", "/", sep="")
file <- "GO_Reversed_both.txt"
write.table(results, paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)

####################################################################
#################### GO ON NON-REVERSED GENES ######################
####################################################################

# Define gene names
gene_short_names <- unique(df[which(df$reversed=="no"), "gene_short_name"])

# GO
marvel <- list()

marvel <- BioPathways(MarvelObject=marvel,
                      method.adjust="fdr",
                      custom.genes=gene_short_names,
                      species="human"
                      )

results <- marvel$DE$BioPathways$Table

# Save file
path <- paste("/Users/seanwen/Documents/Hanifi/MARVEL/Pct Reversal/dCas13/", "SE", "/", sep="")
file <- "DM1 dCas13 treated vs WT dCas13 placebo_GO_Non-Reversed.txt"
write.table(results, paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)

####################################################################

