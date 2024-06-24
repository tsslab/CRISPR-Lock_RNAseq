# Load packages
library(data.table)
library(plyr)
library(MARVEL)
library(ggplot2)

#################################################################################
########################### SPLICING INPUT FILES ################################
#################################################################################

# Read splice junction counts file
path <- "/Users/seanwen/Documents/Hanifi/SJ/"
file <- "SJ.txt"
sj <- as.data.frame(fread(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA"))

# Read phenoData (sample metadata)
path <- "/Users/seanwen/Documents/Hanifi/SJ/"
file <- "SJ_phenoData.txt"
df.pheno <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")

# Read featureData (splicing metadata)
    # SE
    path <- "/Users/seanwen/Documents/Hanifi/rMATS/ASEvents_MARVEL_Formatted/SE/"
    file <- "SE_featureData.txt"
    df.feature.se <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")
    
    # MXE
    path <- "/Users/seanwen/Documents/Hanifi/rMATS/ASEvents_MARVEL_Formatted/MXE/"
    file <- "MXE_featureData.txt"
    df.feature.mxe <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")
        
    # RI
    path <- "/Users/seanwen/Documents/Hanifi/rMATS/ASEvents_MARVEL_Formatted/RI/"
    file <- "RI_featureData.txt"
    df.feature.ri <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")
        
    # A5SS
    path <- "/Users/seanwen/Documents/Hanifi/rMATS/ASEvents_MARVEL_Formatted/A5SS/"
    file <- "A5SS_featureData.txt"
    df.feature.a5ss <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")
            
    # A3SS
    path <- "/Users/seanwen/Documents/Hanifi/rMATS/ASEvents_MARVEL_Formatted/A3SS/"
    file <- "A3SS_featureData.txt"
    df.feature.a3ss <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")
        
    # Merge
    df.feature.list <- list(df.feature.se, df.feature.mxe, df.feature.ri, df.feature.a5ss, df.feature.a3ss)
    names(df.feature.list) <- c("SE", "MXE", "RI", "A5SS", "A3SS")
    
# Intron coverage
path <- "/Users/seanwen/Documents/Hanifi/MARVEL/PSI/RI/"
file <- "Counts_by_Region.txt"
df.intron.counts <- as.data.frame(fread(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA"))

#################################################################################
############################## GENE INPUT FILES #################################
#################################################################################

# Read phenoData (sample metadata)
path <- "/Users/seanwen/Documents/Hanifi/featureCounts/"
file <- "Counts_phenoData_TechRepMerged.txt"
df.cpm.pheno <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE)

# Read featureData (gene metadata)
path <- "/Users/seanwen/Documents/Hanifi/featureCounts/"
file <- "Counts_featureData_TechRepMerged.txt"
df.cpm.feature <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE)

# Read matrix
path <- "/Users/seanwen/Documents/Hanifi/featureCounts/"
file <- "CPM-log2_TechRepMerged.txt"
df.cpm <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE)

# GTF
path <- "/Users/seanwen/Documents/U2AF1_2019/GTF/"
file <- "gencode.v31.annotation.gtf"
gtf <- as.data.frame(fread(paste(path, file, sep=""), sep="\t", header=FALSE, stringsAsFactors=FALSE, na.strings="NA", quote="\""))

#################################################################################
########################## CREATE MARVEL OBJECT #################################
#################################################################################

# Create MARVEL object
marvel <- CreateMarvelObject(SpliceJunction=sj,
                             SplicePheno=df.pheno,
                             SpliceFeature=df.feature.list,
                             IntronCounts=df.intron.counts,
                             GenePheno=df.cpm.pheno,
                             GeneFeature=df.cpm.feature,
                             Exp=df.cpm,
                             GTF=gtf
                             )

#################################################################################
############################## DETECT EVENTS ####################################
#################################################################################

# ALE
marvel <- DetectEvents(MarvelObject=marvel,
                       min.cells=6,
                       min.expr=1,
                       track.progress=TRUE,
                       EventType="ALE"
                       )

# AFE
marvel <- DetectEvents(MarvelObject=marvel,
                       min.cells=6,
                       min.expr=1,
                       track.progress=TRUE,
                       EventType="AFE"
                       )
                       
#################################################################################
################################ COMPUTE PSI ####################################
#################################################################################

# Check alignment
marvel <- CheckAlignment(MarvelObject=marvel, level="SJ")

# Validated and filter splicing events, compute PSI
    # SE
    marvel <- ComputePSI(MarvelObject=marvel,
                         CoverageThreshold=10,
                         UnevenCoverageMultiplier=10,
                         EventType="SE"
                         )
    
    # MXE
    marvel <- ComputePSI(MarvelObject=marvel,
                         CoverageThreshold=10,
                         UnevenCoverageMultiplier=10,
                         EventType="MXE"
                         )
    
    # A5SS
    marvel <- ComputePSI(MarvelObject=marvel,
                         CoverageThreshold=10,
                         EventType="A5SS"
                         )

    # A3SS
    marvel <- ComputePSI(MarvelObject=marvel,
                         CoverageThreshold=10,
                         EventType="A3SS"
                         )
    
    # RI
    marvel <- ComputePSI(MarvelObject=marvel,
                         CoverageThreshold=10,
                         EventType="RI",
                         thread=4,
                         read.length=150
                         )
                         
    # ALE
    marvel <- ComputePSI(MarvelObject=marvel,
                         CoverageThreshold=10,
                         EventType="ALE"
                         )
    
    # AFE
    marvel <- ComputePSI(MarvelObject=marvel,
                         CoverageThreshold=10,
                         EventType="AFE"
                         )

# Save files
    # SE
    path <- "/Users/seanwen/Documents/Hanifi/MARVEL/PSI/SE/"
    file <- "SE.txt"
    write.table(marvel$PSI$SE, paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)
    
    path <- "/Users/seanwen/Documents/Hanifi/MARVEL/PSI/SE/"
    file <- "SE_featureData_Validated.txt"
    write.table(marvel$SpliceFeatureValidated$SE, paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)
    
    # MXE
    path <- "/Users/seanwen/Documents/Hanifi/MARVEL/PSI/MXE/"
    file <- "MXE.txt"
    write.table(marvel$PSI$MXE, paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)
    
    path <- "/Users/seanwen/Documents/Hanifi/MARVEL/PSI/MXE/"
    file <- "MXE_featureData_Validated.txt"
    write.table(marvel$SpliceFeatureValidated$MXE, paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)
    
    # RI
    path <- "/Users/seanwen/Documents/Hanifi/MARVEL/PSI/RI/"
    file <- "RI.txt"
    write.table(marvel$PSI$RI, paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)
    
    path <- "/Users/seanwen/Documents/Hanifi/MARVEL/PSI/RI/"
    file <- "RI_featureData_Validated.txt"
    write.table(marvel$SpliceFeatureValidated$RI, paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)

    # A5SS
    path <- "/Users/seanwen/Documents/Hanifi/MARVEL/PSI/A5SS/"
    file <- "A5SS.txt"
    write.table(marvel$PSI$A5SS, paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)
    
    path <- "/Users/seanwen/Documents/Hanifi/MARVEL/PSI/A5SS/"
    file <- "A5SS_featureData_Validated.txt"
    write.table(marvel$SpliceFeatureValidated$A5SS, paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)
    
    # A3SS
    path <- "/Users/seanwen/Documents/Hanifi/MARVEL/PSI/A3SS/"
    file <- "A3SS.txt"
    write.table(marvel$PSI$A3SS, paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)
    
    path <- "/Users/seanwen/Documents/Hanifi/MARVEL/PSI/A3SS/"
    file <- "A3SS_featureData_Validated.txt"
    write.table(marvel$SpliceFeatureValidated$A3SS, paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)
    
    # ALE
    path <- "/Users/seanwen/Documents/Hanifi/MARVEL/PSI/ALE/"
    file <- "ALE.txt"
    write.table(marvel$PSI$ALE, paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)
    
    path <- "/Users/seanwen/Documents/Hanifi/MARVEL/PSI/ALE/"
    file <- "ALE_featureData_Validated.txt"
    write.table(marvel$SpliceFeatureValidated$ALE, paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)
    
    # AFE
    path <- "/Users/seanwen/Documents/Hanifi/MARVEL/PSI/AFE/"
    file <- "AFE.txt"
    write.table(marvel$PSI$AFE, paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)
    
    path <- "/Users/seanwen/Documents/Hanifi/MARVEL/PSI/AFE/"
    file <- "AFE_featureData_Validated.txt"
    write.table(marvel$SpliceFeatureValidated$AFE, paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)
    
#################################################################################
############################ PRE-PROCESS DATA ###################################
#################################################################################

# Subset relevant samples: Splicing data
#marvel <- SubsetSamples(MarvelObject=marvel,
                        #columns=c("qc.seq", "sample.type", "cell.type"),
                        #variables=list("pass", "Single Cell", c("iPSC", "Endoderm")),
                        #level="splicing"
                        #)

# Subset relevant samples: Gene data
#marvel <- SubsetSamples(MarvelObject=marvel,
                        #columns=c("qc.seq", "sample.type", "cell.type"),
                        #variables=list("pass", "Single Cell", c("iPSC", "Endoderm")),
                        #level="gene"
                        #)
                        
# Check sample and splicing metadata alignment with matrix columns and rows
marvel <- CheckAlignment(MarvelObject=marvel, level="splicing")

# Check sample and gene metadata alignment with matrix columns and rows
marvel <- CheckAlignment(MarvelObject=marvel, level="gene")

# Check splicing and gene metadata alignment
marvel <- CheckAlignment(MarvelObject=marvel, level="splicing and gene")

# Transform gene expression values
#marvel <- TransformExpValues(MarvelObject=marvel)

#################################################################################

# Save R object
path <- "/Users/seanwen/Documents/Hanifi/MARVEL/R Object/"
file <- "MARVEL.RData"
save(marvel, file=paste(path, file, sep=""))
