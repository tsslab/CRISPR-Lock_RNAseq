# Load packages
library(MARVEL)
library(plyr)
library(ggplot2)

# Load MARVEL object
path <- "C:/Users/mhanifi/MARVEL/R Object/"
file <- "MARVEL.RData"
load(file=paste(path, file, sep=""))

#################################################################
############### ACTIVATION OF VIRAL PATHWAYS - ASO ##############
#################################################################

# Read GO output
path <- "C:/Users/mhanifi/DESeq2/DESeq2/ClusterProfiler/"
file <- "DM1 ASO placebo vs DM1 untreated_Up-regulated Genes.txt"
df <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")

# Subset sig terms
index <- which(df$p.adjust < 0.01)
df <- df[index, ]

# Subset GO related to viral activation
vir <- c("GO:0048524", "GO:0009615", "GO:0051607", "GO:0039528", "GO:0071360", "GO:0016236", "GO:2001233", "GO:0097193", "GO:0032606", "GO:0032479", "GO:0060337", "GO:0071357", "GO:0035455", "GO:0034612")
df <- df[df$ID %in% vir, ]

# Insert table into MARVEL slot
marvel$DE$BioPathways$Table <- df

# Define top pathways
go.terms <- df$Description[c(1:14)]

# Plot
marvel <- BioPathways.Plot(MarvelObject=marvel,
                           go.terms=go.terms,
                           y.label.size=8
                           )


marvel$DE$BioPathways$Plot

# Save plot
#path <- "/Users/seanwen/Documents/Hanifi/MARVEL/DE/GO/"
#file <- "SE_ASO_Plot_TopPathways.pdf"
#ggsave(paste(path, file, sep=""), marvel$DE$BioPathways$Plot, width=5, height=4)

#################################################################
############ ACTIVATION OF VIRAL PATHWAYS - dCas13 ##############
#################################################################

# Read GO output
path <- "C:/Users/mhanifi/DESeq2/DESeq2/ClusterProfiler/"
file <- "DM1 dCas13 placebo vs DM1 untreated_Up-regulated Genes.txt"
df <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")

# Subset sig terms
index <- which(df$p.adjust < 0.01)
df <- df[index, ]

# Subset GO related to viral activation
vir <- c("GO:0048524", "GO:0009615", "GO:0051607", "GO:0039528", "GO:0071360", "GO:0016236", "GO:2001233", "GO:0097193", "GO:0032606", "GO:0032479", "GO:0060337", "GO:0071357", "GO:0035455", "GO:0034612")
df <- df[df$ID %in% vir, ]

# Insert table into MARVEL slot
marvel$DE$BioPathways$Table <- df

# Define top pathways
go.terms <- df$Description[c(1:14)]

# Subset GO related to viral activation
vir <- c("GO:0048524", "GO:0009615", "GO:0051607", "GO:0039528", "GO:0071360", "GO:0016236", "GO:2001233", "GO:0097193", "GO:0032606", "GO:0032479", "GO:0060337", "GO:0071357", "GO:0035455", "GO:0034612")
df <- df[df$ID %in% vir, ]

# Plot
marvel <- BioPathways.Plot(MarvelObject=marvel,
                           go.terms=go.terms,
                           y.label.size=8
                           )


marvel$DE$BioPathways$Plot

# Save plot
#path <- "/Users/seanwen/Documents/Hanifi/MARVEL/DE/GO/"
#file <- "SE_dCas13_Plot_TopPathways.pdf"
#ggsave(paste(path, file, sep=""), marvel$DE$BioPathways$Plot, width=5, height=4)

#################################################################
###################### ASO-dCas13 Overlap #######################
#################################################################

# Read GO output
path <- "/Users/seanwen/Documents/Hanifi/MARVEL/DE/GO/"
file <- "SE_ASO-dCas13_Overlap.txt"
df <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")

# Subset sig terms
index <- which(df$p.adjust < 0.01)
df <- df[index, ]

# Insert table into MARVEL slot
marvel$DE$BioPathways$Table <- df

# Define top pathways
go.terms <- df$Description[c(1:10)]

# Plot
marvel <- BioPathways.Plot(MarvelObject=marvel,
                           go.terms=go.terms,
                           y.label.size=8
                           )


marvel$DE$BioPathways$Plot

# Save plot
path <- "/Users/seanwen/Documents/Hanifi/MARVEL/DE/GO/"
file <- "SE_ASO-dCas13_Overlap_TopPathways.pdf"
ggsave(paste(path, file, sep=""), marvel$DE$BioPathways$Plot, width=5, height=4)
