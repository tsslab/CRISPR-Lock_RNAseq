# Load packages
library(MARVEL)

# Define event types
event_types <- c("SE", "MXE", "RI", "A5SS", "A3SS", "AFE", "ALE")


# Read file
path <- "C:/Users/mhanifi/MARVEL/DE/Tables/"
file <- "df.2.small.dCas13.txt"
df <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")

####################################################################
############### GO ON ALL EVENTS REVERSED BY dCas13 ################
####################################################################

# Define gene names
gene_short_names <- unique(df[which(df$reversed=="yes" | df$reversed=="partial"), "gene_short_name"])

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
file <- "GO_All_Reversed_dCas13.txt"
write.table(results, paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)

####################################################################
############# GO ON ALL EVENTS NOT REVERSED BY dCas13 ##############
####################################################################

# Define gene names
gene_short_names <- unique(df[which(df$reversed=="no" | df$reversed=="worse"), "gene_short_name"])

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
file <- "GO_All_Non-reversed_dCas13.txt"
write.table(results, paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)

####################################################################

