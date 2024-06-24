# Load packages
library(MARVEL)
library(plyr)
library(ggplot2)

# Load MARVEL object
path <- "/Users/seanwen/Documents/Hanifi/MARVEL/R Object/"
file <- "MARVEL.RData"
load(file=paste(path, file, sep=""))

#################################################################
############################## ASO ##############################
#################################################################

# Read GO output
path <- "/Users/seanwen/Documents/Hanifi/MARVEL/DE/GO/"
file <- "SE_ASO.txt"
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
file <- "SE_ASO_Plot_TopPathways.pdf"
ggsave(paste(path, file, sep=""), marvel$DE$BioPathways$Plot, width=5, height=4)

#################################################################
########################### dCas13 ##############################
#################################################################

# Read GO output
path <- "/Users/seanwen/Documents/Hanifi/MARVEL/DE/GO/"
file <- "SE_dCas13.txt"
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
file <- "SE_dCas13_Plot_TopPathways.pdf"
ggsave(paste(path, file, sep=""), marvel$DE$BioPathways$Plot, width=5, height=4)

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
