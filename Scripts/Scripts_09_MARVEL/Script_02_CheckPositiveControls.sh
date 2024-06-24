# Load packages
library(MARVEL)

# Load MARVEL object
path <- "/Users/seanwen/Documents/Hanifi/MARVEL/R Object/"
file <- "MARVEL.RData"
load(file=paste(path, file, sep=""))

# Read +ve ctrls
    # Read file
    path <- "/Users/seanwen/Documents/Hanifi/Positive Controls/"
    file <- "SE_featureData.txt"
    df.feature.se <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")

    # Subset sig events
    gene_short_names <- c("MBNL1", "MBNL2", "DMD")
    df.feature.se <- df.feature.se[which(df.feature.se$gene_short_name %in% gene_short_names), ]

# Manually check if sig events validated
    # Retrieve validated featureData
    df.feature <- marvel$SpliceFeatureValidated$SE
    
    # Check
    df.feature[which(df.feature$tran_id %in% df.feature.se$tran_id), ] # MBNL1, MBNL2 found
    
    # Check DMD tran_id
    df.feature[which(df.feature$gene_short_name %in% "DMD"), ]
    # chrX:31134102:31134194:-@chrX:31126642:31126673:-@chrX:31119225:31121930 - rMATS
    # chrX:31134102:31134194:-@chrX:31126642:31126673:-@chrX:31119228:31121930 - Hanifi
    # Differed only by the 3' end of the 3' constitutive exon, but same SJ coordinates at the 5' end of the 3' constitutive exon - OK
    # Replace Hanifi's tran_id with rMATS tran_id in SE_featureData.txt
    # Re-run Scripts_06_Positive Controls/Script_02_CreateMarvelObject_ComputePSI_Plot
    # Use rMATS's tran_id moving forward
    
    

