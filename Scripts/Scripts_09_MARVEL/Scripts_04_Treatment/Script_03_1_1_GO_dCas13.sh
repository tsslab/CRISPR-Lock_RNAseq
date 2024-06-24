# Load packages
library(MARVEL)

# Define event types
event_types <- c("SE", "MXE", "RI", "A5SS", "A3SS", "AFE", "ALE")


# Read file
path <- paste("/Users/seanwen/Documents/Hanifi/MARVEL/Pct Reversal/dCas13/", "SE", "/", sep="")
file <- "DM1 dCas13 treated vs WT dCas13 placebo.txt"
df <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")

####################################################################
####################### GO ON REVERSED GENES #######################
####################################################################

# Define gene names
gene_short_names <- unique(df[which(df$reversed=="yes"), "gene_short_name"])

# GO
marvel <- list()

marvel <- BioPathways(MarvelObject=marvel,
                      method.adjust="fdr",
                      custom.genes=gene_short_names,
                      species="human"
                      )

results <- marvel$DE$BioPathways$Table

# Save file
path <- paste("/Users/seanwen/Documents/Hanifi/MARVEL/Pct Reversal/dCas13/", event_types[1], "/", sep="")
file <- "DM1 dCas13 treated vs WT dCas13 placebo_GO_Reversed.txt"
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

