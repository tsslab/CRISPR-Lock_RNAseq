# Load packages
library(plyr)
library(ggplot2)
library(ggrepel)
library(dplyr)
library(data.table)
library(stringr)

# Read DE outputs
  # Untreated vs WT
    # SE events
    path <- "C:/Users/Ania/"
    file <- "untr_vs_wt_AS_SE.txt"
    df.1.SE <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")
    df.1.SE$Event_ID <- paste0(df.1.SE$chr, df.1.SE$strand, df.1.SE$exonStart_0base, df.1.SE$exonEnd, df.1.SE$upstreamES, df.1.SE$upstreamEE, df.1.SE$downstreamES, df.1.SE$downstreamEE)
    df.1.SE$chr <- NULL
    df.1.SE$strand <- NULL
    df.1.SE$exonStart_0base <- NULL
    df.1.SE$exonEnd <- NULL
    df.1.SE$upstreamES <- NULL
    df.1.SE$upstreamEE <- NULL
    df.1.SE$downstreamES <- NULL
    df.1.SE$downstreamEE <- NULL
    df.1.SE$Event_type <- "SE"

    # RI events
    path <- "C:/Users/Ania/"
    file <- "untr_vs_wt_AS_RI.txt"
    df.1.RI <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")
    df.1.RI$Event_ID <- paste0(df.1.RI$chr, df.1.RI$strand, df.1.RI$riExonStart_0base, df.1.RI$riExonEnd, df.1.RI$upstreamES, df.1.RI$upstreamEE, df.1.RI$downstreamES, df.1.RI$downstreamEE)
    df.1.RI$chr <- NULL
    df.1.RI$strand <- NULL
    df.1.RI$riExonStart_0base <- NULL
    df.1.RI$riExonEnd <- NULL
    df.1.RI$upstreamES <- NULL
    df.1.RI$upstreamEE <- NULL
    df.1.RI$downstreamES <- NULL
    df.1.RI$downstreamEE <- NULL
    df.1.RI$Event_type <- "RI"
  
    # MXE events
    path <- "C:/Users/Ania/"
    file <- "untr_vs_wt_AS_MXE.txt"
    df.1.MXE <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")
    df.1.MXE$Event_ID <- paste0(df.1.MXE$chr, df.1.MXE$strand, df.1.MXE$X1stExonStart_0base, df.1.MXE$X1stExonEnd, df.1.MXE$X2ndExonStart_0base, df.1.MXE$X2ndExonEnd, df.1.MXE$upstreamES, df.1.MXE$upstreamEE, df.1.MXE$downstreamES, df.1.MXE$downstreamEE)
    df.1.MXE$chr <- NULL
    df.1.MXE$strand <- NULL
    df.1.MXE$X1stExonStart_0base <- NULL
    df.1.MXE$X1stExonEnd <- NULL
    df.1.MXE$X2ndExonStart_0base <- NULL
    df.1.MXE$X2ndExonEnd <- NULL
    df.1.MXE$upstreamES <- NULL
    df.1.MXE$upstreamEE <- NULL
    df.1.MXE$downstreamES <- NULL
    df.1.MXE$downstreamEE <- NULL
    df.1.MXE$Event_type <- "MXE"
  
    # A5SS events
    path <- "C:/Users/Ania/"
    file <- "untr_vs_wt_AS_A5SS.txt"
    df.1.A5SS <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")
    df.1.A5SS$Event_ID <- paste0(df.1.A5SS$chr, df.1.A5SS$strand, df.1.A5SS$longExonStart_0base, df.1.A5SS$longExonEnd, df.1.A5SS$shortES, df.1.A5SS$shortEE, df.1.A5SS$flankingES, df.1.A5SS$flankingEE)
    df.1.A5SS$chr <- NULL
    df.1.A5SS$strand <- NULL
    df.1.A5SS$longExonStart_0base <- NULL
    df.1.A5SS$longExonEnd <- NULL
    df.1.A5SS$shortES <- NULL
    df.1.A5SS$shortEE <- NULL
    df.1.A5SS$flankingES <- NULL
    df.1.A5SS$flankingEE <- NULL
    df.1.A5SS$Event_type <- "A5SS"
  
    # A3SS events
    path <- "C:/Users/Ania/"
    file <- "untr_vs_wt_AS_A3SS.txt"
    df.1.A3SS <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")
    df.1.A3SS$Event_ID <- paste0(df.1.A3SS$chr, df.1.A3SS$strand, df.1.A3SS$longExonStart_0base, df.1.A3SS$longExonEnd, df.1.A3SS$shortES, df.1.A3SS$shortEE, df.1.A3SS$flankingES, df.1.A3SS$flankingEE)
    df.1.A3SS$chr <- NULL
    df.1.A3SS$strand <- NULL
    df.1.A3SS$longExonStart_0base <- NULL
    df.1.A3SS$longExonEnd <- NULL
    df.1.A3SS$shortES <- NULL
    df.1.A3SS$shortEE <- NULL
    df.1.A3SS$flankingES <- NULL
    df.1.A3SS$flankingEE <- NULL
    df.1.A3SS$Event_type <- "A3SS"
  
    # merge all event types
    df.1 <- rbind(df.1.SE, df.1.RI, df.1.MXE, df.1.A5SS, df.1.A3SS)
    df.1.A3SS <- NULL
    df.1.A5SS <- NULL
    df.1.MXE <- NULL
    df.1.RI <- NULL
    df.1.SE <- NULL
  
    
  # Nusinersen vs control
    # SE events
    path <- "C:/Users/Ania/"
    file <- "nusinersen_vs_control_SE.txt"
    df.2.SE <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")
    df.2.SE$Event_ID <- paste0(df.2.SE$chr, df.2.SE$strand, df.2.SE$exonStart_0base, df.2.SE$exonEnd, df.2.SE$upstreamES, df.2.SE$upstreamEE, df.2.SE$downstreamES, df.2.SE$downstreamEE)
    df.2.SE$chr <- NULL
    df.2.SE$strand <- NULL
    df.2.SE$exonStart_0base <- NULL
    df.2.SE$exonEnd <- NULL
    df.2.SE$upstreamES <- NULL
    df.2.SE$upstreamEE <- NULL
    df.2.SE$downstreamES <- NULL
    df.2.SE$downstreamEE <- NULL
    df.2.SE$Event_type <- "SE"
    
    # RI events
    path <- "C:/Users/Ania/"
    file <- "nusinersen_vs_control_RI.txt"
    df.2.RI <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")
    df.2.RI$Event_ID <- paste0(df.2.RI$chr, df.2.RI$strand, df.2.RI$riExonStart_0base, df.2.RI$riExonEnd, df.2.RI$upstreamES, df.2.RI$upstreamEE, df.2.RI$downstreamES, df.2.RI$downstreamEE)
    df.2.RI$chr <- NULL
    df.2.RI$strand <- NULL
    df.2.RI$riExonStart_0base <- NULL
    df.2.RI$riExonEnd <- NULL
    df.2.RI$upstreamES <- NULL
    df.2.RI$upstreamEE <- NULL
    df.2.RI$downstreamES <- NULL
    df.2.RI$downstreamEE <- NULL
    df.2.RI$Event_type <- "RI"
    
    # MXE events
    path <- "C:/Users/Ania/"
    file <- "nusinersen_vs_control_MXE.txt"
    df.2.MXE <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")
    df.2.MXE$Event_ID <- paste0(df.2.MXE$chr, df.2.MXE$strand, df.2.MXE$X1stExonStart_0base, df.2.MXE$X1stExonEnd, df.2.MXE$X2ndExonStart_0base, df.2.MXE$X2ndExonEnd, df.2.MXE$upstreamES, df.2.MXE$upstreamEE, df.2.MXE$downstreamES, df.2.MXE$downstreamEE)
    df.2.MXE$chr <- NULL
    df.2.MXE$strand <- NULL
    df.2.MXE$X1stExonStart_0base <- NULL
    df.2.MXE$X1stExonEnd <- NULL
    df.2.MXE$X2ndExonStart_0base <- NULL
    df.2.MXE$X2ndExonEnd <- NULL
    df.2.MXE$upstreamES <- NULL
    df.2.MXE$upstreamEE <- NULL
    df.2.MXE$downstreamES <- NULL
    df.2.MXE$downstreamEE <- NULL
    df.2.MXE$Event_type <- "MXE"
    
    # A5SS events
    path <- "C:/Users/Ania/"
    file <- "nusinersen_vs_control_A5SS.txt"
    df.2.A5SS <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")
    df.2.A5SS$Event_ID <- paste0(df.2.A5SS$chr, df.2.A5SS$strand, df.2.A5SS$longExonStart_0base, df.2.A5SS$longExonEnd, df.2.A5SS$shortES, df.2.A5SS$shortEE, df.2.A5SS$flankingES, df.2.A5SS$flankingEE)
    df.2.A5SS$chr <- NULL
    df.2.A5SS$strand <- NULL
    df.2.A5SS$longExonStart_0base <- NULL
    df.2.A5SS$longExonEnd <- NULL
    df.2.A5SS$shortES <- NULL
    df.2.A5SS$shortEE <- NULL
    df.2.A5SS$flankingES <- NULL
    df.2.A5SS$flankingEE <- NULL
    df.2.A5SS$Event_type <- "A5SS"
    
    # A3SS events
    path <- "C:/Users/Ania/"
    file <- "nusinersen_vs_control_A3SS.txt"
    df.2.A3SS <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")
    df.2.A3SS$Event_ID <- paste0(df.2.A3SS$chr, df.2.A3SS$strand, df.2.A3SS$longExonStart_0base, df.2.A3SS$longExonEnd, df.2.A3SS$shortES, df.2.A3SS$shortEE, df.2.A3SS$flankingES, df.2.A3SS$flankingEE)
    df.2.A3SS$chr <- NULL
    df.2.A3SS$strand <- NULL
    df.2.A3SS$longExonStart_0base <- NULL
    df.2.A3SS$longExonEnd <- NULL
    df.2.A3SS$shortES <- NULL
    df.2.A3SS$shortEE <- NULL
    df.2.A3SS$flankingES <- NULL
    df.2.A3SS$flankingEE <- NULL
    df.2.A3SS$Event_type <- "A3SS"
    
    # merge all event types
    df.2 <- rbind(df.2.SE, df.2.RI, df.2.MXE, df.2.A5SS, df.2.A3SS)    
    df.2.A3SS <- NULL
    df.2.A5SS <- NULL
    df.2.MXE <- NULL
    df.2.RI <- NULL
    df.2.SE <- NULL
    
    
  # MS023nusin vs wt
    # SE events
    path <- "C:/Users/Ania/"
    file <- "MS023nusin_vs_wt_AS_SE.txt"
    df.3.SE <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")
    df.3.SE$Event_ID <- paste0(df.3.SE$chr, df.3.SE$strand, df.3.SE$exonStart_0base, df.3.SE$exonEnd, df.3.SE$upstreamES, df.3.SE$upstreamEE, df.3.SE$downstreamES, df.3.SE$downstreamEE)
    df.3.SE$chr <- NULL
    df.3.SE$strand <- NULL
    df.3.SE$exonStart_0base <- NULL
    df.3.SE$exonEnd <- NULL
    df.3.SE$upstreamES <- NULL
    df.3.SE$upstreamEE <- NULL
    df.3.SE$downstreamES <- NULL
    df.3.SE$downstreamEE <- NULL
    df.3.SE$Event_type <- "SE"
    
    # RI events
    path <- "C:/Users/Ania/"
    file <- "MS023nusin_vs_wt_AS_RI.txt"
    df.3.RI <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")
    df.3.RI$Event_ID <- paste0(df.3.RI$chr, df.3.RI$strand, df.3.RI$riExonStart_0base, df.3.RI$riExonEnd, df.3.RI$upstreamES, df.3.RI$upstreamEE, df.3.RI$downstreamES, df.3.RI$downstreamEE)
    df.3.RI$chr <- NULL
    df.3.RI$strand <- NULL
    df.3.RI$riExonStart_0base <- NULL
    df.3.RI$riExonEnd <- NULL
    df.3.RI$upstreamES <- NULL
    df.3.RI$upstreamEE <- NULL
    df.3.RI$downstreamES <- NULL
    df.3.RI$downstreamEE <- NULL
    df.3.RI$Event_type <- "RI"
    
    # MXE events
    path <- "C:/Users/Ania/"
    file <- "MS023nusin_vs_wt_AS_MXE.txt"
    df.3.MXE <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")
    df.3.MXE$Event_ID <- paste0(df.3.MXE$chr, df.3.MXE$strand, df.3.MXE$X1stExonStart_0base, df.3.MXE$X1stExonEnd, df.3.MXE$X2ndExonStart_0base, df.3.MXE$X2ndExonEnd, df.3.MXE$upstreamES, df.3.MXE$upstreamEE, df.3.MXE$downstreamES, df.3.MXE$downstreamEE)
    df.3.MXE$chr <- NULL
    df.3.MXE$strand <- NULL
    df.3.MXE$X1stExonStart_0base <- NULL
    df.3.MXE$X1stExonEnd <- NULL
    df.3.MXE$X2ndExonStart_0base <- NULL
    df.3.MXE$X2ndExonEnd <- NULL
    df.3.MXE$upstreamES <- NULL
    df.3.MXE$upstreamEE <- NULL
    df.3.MXE$downstreamES <- NULL
    df.3.MXE$downstreamEE <- NULL
    df.3.MXE$Event_type <- "MXE"
    
    # A5SS events
    path <- "C:/Users/Ania/"
    file <- "MS023nusin_vs_wt_AS_A5SS.txt"
    df.3.A5SS <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")
    df.3.A5SS$Event_ID <- paste0(df.3.A5SS$chr, df.3.A5SS$strand, df.3.A5SS$longExonStart_0base, df.3.A5SS$longExonEnd, df.3.A5SS$shortES, df.3.A5SS$shortEE, df.3.A5SS$flankingES, df.3.A5SS$flankingEE)
    df.3.A5SS$chr <- NULL
    df.3.A5SS$strand <- NULL
    df.3.A5SS$longExonStart_0base <- NULL
    df.3.A5SS$longExonEnd <- NULL
    df.3.A5SS$shortES <- NULL
    df.3.A5SS$shortEE <- NULL
    df.3.A5SS$flankingES <- NULL
    df.3.A5SS$flankingEE <- NULL
    df.3.A5SS$Event_type <- "A5SS"
    
    # A3SS events
    path <- "C:/Users/Ania/"
    file <- "MS023nusin_vs_wt_AS_A3SS.txt"
    df.3.A3SS <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")
    df.3.A3SS$Event_ID <- paste0(df.3.A3SS$chr, df.3.A3SS$strand, df.3.A3SS$longExonStart_0base, df.3.A3SS$longExonEnd, df.3.A3SS$shortES, df.3.A3SS$shortEE, df.3.A3SS$flankingES, df.3.A3SS$flankingEE)
    df.3.A3SS$chr <- NULL
    df.3.A3SS$strand <- NULL
    df.3.A3SS$longExonStart_0base <- NULL
    df.3.A3SS$longExonEnd <- NULL
    df.3.A3SS$shortES <- NULL
    df.3.A3SS$shortEE <- NULL
    df.3.A3SS$flankingES <- NULL
    df.3.A3SS$flankingEE <- NULL
    df.3.A3SS$Event_type <- "A3SS"
    
    # merge all event types
    df.3 <- rbind(df.3.SE, df.3.RI, df.3.MXE, df.3.A5SS, df.3.A3SS)    
    df.3.A3SS <- NULL
    df.3.A5SS <- NULL
    df.3.MXE <- NULL
    df.3.RI <- NULL
    df.3.SE <- NULL

        
  # MS023 vs WT
    # SE events
    path <- "C:/Users/Ania/"
    file <- "MS023_vs_WT_SE.txt"
    df.4.SE <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")
    df.4.SE$Event_ID <- paste0(df.4.SE$chr, df.4.SE$strand, df.4.SE$exonStart_0base, df.4.SE$exonEnd, df.4.SE$upstreamES, df.4.SE$upstreamEE, df.4.SE$downstreamES, df.4.SE$downstreamEE)
    df.4.SE$chr <- NULL
    df.4.SE$strand <- NULL
    df.4.SE$exonStart_0base <- NULL
    df.4.SE$exonEnd <- NULL
    df.4.SE$upstreamES <- NULL
    df.4.SE$upstreamEE <- NULL
    df.4.SE$downstreamES <- NULL
    df.4.SE$downstreamEE <- NULL
    df.4.SE$Event_type <- "SE"
    
    # RI events
    path <- "C:/Users/Ania/"
    file <- "MS023_vs_WT_RI.txt"
    df.4.RI <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")
    df.4.RI$Event_ID <- paste0(df.4.RI$chr, df.4.RI$strand, df.4.RI$riExonStart_0base, df.4.RI$riExonEnd, df.4.RI$upstreamES, df.4.RI$upstreamEE, df.4.RI$downstreamES, df.4.RI$downstreamEE)
    df.4.RI$chr <- NULL
    df.4.RI$strand <- NULL
    df.4.RI$riExonStart_0base <- NULL
    df.4.RI$riExonEnd <- NULL
    df.4.RI$upstreamES <- NULL
    df.4.RI$upstreamEE <- NULL
    df.4.RI$downstreamES <- NULL
    df.4.RI$downstreamEE <- NULL
    df.4.RI$Event_type <- "RI"
    
    # MXE events
    path <- "C:/Users/Ania/"
    file <- "MS023_vs_WT_MXE.txt"
    df.4.MXE <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")
    df.4.MXE$Event_ID <- paste0(df.4.MXE$chr, df.4.MXE$strand, df.4.MXE$X1stExonStart_0base, df.4.MXE$X1stExonEnd, df.4.MXE$X2ndExonStart_0base, df.4.MXE$X2ndExonEnd, df.4.MXE$upstreamES, df.4.MXE$upstreamEE, df.4.MXE$downstreamES, df.4.MXE$downstreamEE)
    df.4.MXE$chr <- NULL
    df.4.MXE$strand <- NULL
    df.4.MXE$X1stExonStart_0base <- NULL
    df.4.MXE$X1stExonEnd <- NULL
    df.4.MXE$X2ndExonStart_0base <- NULL
    df.4.MXE$X2ndExonEnd <- NULL
    df.4.MXE$upstreamES <- NULL
    df.4.MXE$upstreamEE <- NULL
    df.4.MXE$downstreamES <- NULL
    df.4.MXE$downstreamEE <- NULL
    df.4.MXE$Event_type <- "MXE"
    
    # A5SS events
    path <- "C:/Users/Ania/"
    file <- "MS023_vs_WT_A5SS.txt"
    df.4.A5SS <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")
    df.4.A5SS$Event_ID <- paste0(df.4.A5SS$chr, df.4.A5SS$strand, df.4.A5SS$longExonStart_0base, df.4.A5SS$longExonEnd, df.4.A5SS$shortES, df.4.A5SS$shortEE, df.4.A5SS$flankingES, df.4.A5SS$flankingEE)
    df.4.A5SS$chr <- NULL
    df.4.A5SS$strand <- NULL
    df.4.A5SS$longExonStart_0base <- NULL
    df.4.A5SS$longExonEnd <- NULL
    df.4.A5SS$shortES <- NULL
    df.4.A5SS$shortEE <- NULL
    df.4.A5SS$flankingES <- NULL
    df.4.A5SS$flankingEE <- NULL
    df.4.A5SS$Event_type <- "A5SS"
    
    # A3SS events
    path <- "C:/Users/Ania/"
    file <- "MS023_vs_WT_A3SS.txt"
    df.4.A3SS <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")
    df.4.A3SS$Event_ID <- paste0(df.4.A3SS$chr, df.4.A3SS$strand, df.4.A3SS$longExonStart_0base, df.4.A3SS$longExonEnd, df.4.A3SS$shortES, df.4.A3SS$shortEE, df.4.A3SS$flankingES, df.4.A3SS$flankingEE)
    df.4.A3SS$chr <- NULL
    df.4.A3SS$strand <- NULL
    df.4.A3SS$longExonStart_0base <- NULL
    df.4.A3SS$longExonEnd <- NULL
    df.4.A3SS$shortES <- NULL
    df.4.A3SS$shortEE <- NULL
    df.4.A3SS$flankingES <- NULL
    df.4.A3SS$flankingEE <- NULL
    df.4.A3SS$Event_type <- "A3SS"
    
    # merge all event types
    df.4 <- rbind(df.4.SE, df.4.RI, df.4.MXE, df.4.A5SS, df.4.A3SS)    
    df.4.A3SS <- NULL
    df.4.A5SS <- NULL
    df.4.MXE <- NULL
    df.4.RI <- NULL
    df.4.SE <- NULL
    
    
    
# Convert strings in read counts and PSI columns into numeric values
    # Separate string
    df.1$IncLevel1 <- strsplit(df.1$IncLevel1, ",")
    df.1$IncLevel2 <- strsplit(df.1$IncLevel2, ",")
    df.1$IJC_SAMPLE_1 <- strsplit(df.1$IJC_SAMPLE_1, ",")
    df.1$SJC_SAMPLE_1 <- strsplit(df.1$SJC_SAMPLE_1, ",")
    df.1$IJC_SAMPLE_2 <- strsplit(df.1$IJC_SAMPLE_2, ",")
    df.1$SJC_SAMPLE_2 <- strsplit(df.1$SJC_SAMPLE_2, ",")
    
    df.2$IncLevel1 <- strsplit(df.2$IncLevel1, ",")
    df.2$IncLevel2 <- strsplit(df.2$IncLevel2, ",")
    df.2$IJC_SAMPLE_1 <- strsplit(df.2$IJC_SAMPLE_1, ",")
    df.2$SJC_SAMPLE_1 <- strsplit(df.2$SJC_SAMPLE_1, ",")
    df.2$IJC_SAMPLE_2 <- strsplit(df.2$IJC_SAMPLE_2, ",")
    df.2$SJC_SAMPLE_2 <- strsplit(df.2$SJC_SAMPLE_2, ",")
    
    df.3$IncLevel1 <- strsplit(df.3$IncLevel1, ",")
    df.3$IncLevel2 <- strsplit(df.3$IncLevel2, ",")
    df.3$IJC_SAMPLE_1 <- strsplit(df.3$IJC_SAMPLE_1, ",")
    df.3$SJC_SAMPLE_1 <- strsplit(df.3$SJC_SAMPLE_1, ",")
    df.3$IJC_SAMPLE_2 <- strsplit(df.3$IJC_SAMPLE_2, ",")
    df.3$SJC_SAMPLE_2 <- strsplit(df.3$SJC_SAMPLE_2, ",")
    
    df.4$IncLevel1 <- strsplit(df.4$IncLevel1, ",")
    df.4$IncLevel2 <- strsplit(df.4$IncLevel2, ",")
    df.4$IJC_SAMPLE_1 <- strsplit(df.4$IJC_SAMPLE_1, ",")
    df.4$SJC_SAMPLE_1 <- strsplit(df.4$SJC_SAMPLE_1, ",")
    df.4$IJC_SAMPLE_2 <- strsplit(df.4$IJC_SAMPLE_2, ",")
    df.4$SJC_SAMPLE_2 <- strsplit(df.4$SJC_SAMPLE_2, ",")
    
    # Convert string into numeric value
    df.1$IncLevel1 <- lapply(df.1$IncLevel1, as.numeric)
    df.1$IncLevel2 <- lapply(df.1$IncLevel2, as.numeric)
    df.1$IJC_SAMPLE_1 <- lapply(df.1$IJC_SAMPLE_1, as.numeric)
    df.1$SJC_SAMPLE_1 <- lapply(df.1$SJC_SAMPLE_1, as.numeric)
    df.1$IJC_SAMPLE_2 <- lapply(df.1$IJC_SAMPLE_2, as.numeric)
    df.1$SJC_SAMPLE_2 <- lapply(df.1$SJC_SAMPLE_2, as.numeric)
    
    df.2$IncLevel1 <- lapply(df.2$IncLevel1, as.numeric)
    df.2$IncLevel2 <- lapply(df.2$IncLevel2, as.numeric)
    df.2$IJC_SAMPLE_1 <- lapply(df.2$IJC_SAMPLE_1, as.numeric)
    df.2$SJC_SAMPLE_1 <- lapply(df.2$SJC_SAMPLE_1, as.numeric)
    df.2$IJC_SAMPLE_2 <- lapply(df.2$IJC_SAMPLE_2, as.numeric)
    df.2$SJC_SAMPLE_2 <- lapply(df.2$SJC_SAMPLE_2, as.numeric)
    
    df.3$IncLevel1 <- lapply(df.3$IncLevel1, as.numeric)
    df.3$IncLevel2 <- lapply(df.3$IncLevel2, as.numeric)
    df.3$IJC_SAMPLE_1 <- lapply(df.3$IJC_SAMPLE_1, as.numeric)
    df.3$SJC_SAMPLE_1 <- lapply(df.3$SJC_SAMPLE_1, as.numeric)
    df.3$IJC_SAMPLE_2 <- lapply(df.3$IJC_SAMPLE_2, as.numeric)
    df.3$SJC_SAMPLE_2 <- lapply(df.3$SJC_SAMPLE_2, as.numeric)

    df.4$IncLevel1 <- lapply(df.4$IncLevel1, as.numeric)
    df.4$IncLevel2 <- lapply(df.4$IncLevel2, as.numeric)
    df.4$IJC_SAMPLE_1 <- lapply(df.4$IJC_SAMPLE_1, as.numeric)
    df.4$SJC_SAMPLE_1 <- lapply(df.4$SJC_SAMPLE_1, as.numeric)
    df.4$IJC_SAMPLE_2 <- lapply(df.4$IJC_SAMPLE_2, as.numeric)
    df.4$SJC_SAMPLE_2 <- lapply(df.4$SJC_SAMPLE_2, as.numeric)
    
    
    
# Subset events based on total junction read >10; P-value <0.01; consistent replicate number
# Weird replicate numbers on some reads were found; need to be cleaned up
    # count the number of replicates
    for(i in 1:dim(df.1)[1]) {
      df.1$count_IJC_SAMPLE_1[i] <- length(df.1$IJC_SAMPLE_1[i][[1]])
      df.1$count_SJC_SAMPLE_1[i] <- length(df.1$SJC_SAMPLE_1[i][[1]])
      df.1$count_IJC_SAMPLE_2[i] <- length(df.1$IJC_SAMPLE_2[i][[1]])
      df.1$count_SJC_SAMPLE_2[i] <- length(df.1$SJC_SAMPLE_2[i][[1]])
      df.1$count_IncLevel1[i] <- length(df.1$IncLevel1[i][[1]])
      df.1$count_IncLevel2[i] <- length(df.1$IncLevel2[i][[1]])
    }
    
    for(i in 1:dim(df.2)[1]) {
      df.2$count_IJC_SAMPLE_1[i] <- length(df.2$IJC_SAMPLE_1[i][[1]])
      df.2$count_SJC_SAMPLE_1[i] <- length(df.2$SJC_SAMPLE_1[i][[1]])
      df.2$count_IJC_SAMPLE_2[i] <- length(df.2$IJC_SAMPLE_2[i][[1]])
      df.2$count_SJC_SAMPLE_2[i] <- length(df.2$SJC_SAMPLE_2[i][[1]])
      df.2$count_IncLevel1[i] <- length(df.2$IncLevel1[i][[1]])
      df.2$count_IncLevel2[i] <- length(df.2$IncLevel2[i][[1]])
    }
    
    for(i in 1:dim(df.3)[1]) {
      df.3$count_IJC_SAMPLE_1[i] <- length(df.3$IJC_SAMPLE_1[i][[1]])
      df.3$count_SJC_SAMPLE_1[i] <- length(df.3$SJC_SAMPLE_1[i][[1]])
      df.3$count_IJC_SAMPLE_2[i] <- length(df.3$IJC_SAMPLE_2[i][[1]])
      df.3$count_SJC_SAMPLE_2[i] <- length(df.3$SJC_SAMPLE_2[i][[1]])
      df.3$count_IncLevel1[i] <- length(df.3$IncLevel1[i][[1]])
      df.3$count_IncLevel2[i] <- length(df.3$IncLevel2[i][[1]])
    }
    
    for(i in 1:dim(df.4)[1]) {
      df.4$count_IJC_SAMPLE_1[i] <- length(df.4$IJC_SAMPLE_1[i][[1]])
      df.4$count_SJC_SAMPLE_1[i] <- length(df.4$SJC_SAMPLE_1[i][[1]])
      df.4$count_IJC_SAMPLE_2[i] <- length(df.4$IJC_SAMPLE_2[i][[1]])
      df.4$count_SJC_SAMPLE_2[i] <- length(df.4$SJC_SAMPLE_2[i][[1]])
      df.4$count_IncLevel1[i] <- length(df.4$IncLevel1[i][[1]])
      df.4$count_IncLevel2[i] <- length(df.4$IncLevel2[i][[1]])
    }

    # count the number of reads per sample, and decide if they have enough counts   
    for(i in 1:dim(df.1)[1]) {
      df.1$readCount_sample1_replicate1[i] <- df.1$IJC_SAMPLE_1[i][[1]][1] + df.1$SJC_SAMPLE_1[i][[1]][1]
      df.1$readCount_sample1_replicate2[i] <- df.1$IJC_SAMPLE_1[i][[1]][2] + df.1$SJC_SAMPLE_1[i][[1]][2]
      df.1$readCount_sample1_replicate3[i] <- df.1$IJC_SAMPLE_1[i][[1]][3] + df.1$SJC_SAMPLE_1[i][[1]][3]
      df.1$readCount_sample1_replicate4[i] <- df.1$IJC_SAMPLE_1[i][[1]][4] + df.1$SJC_SAMPLE_1[i][[1]][4]
      
      df.1$readCount_sample2_replicate1[i] <- df.1$IJC_SAMPLE_2[i][[1]][1] + df.1$SJC_SAMPLE_2[i][[1]][1]
      df.1$readCount_sample2_replicate2[i] <- df.1$IJC_SAMPLE_2[i][[1]][2] + df.1$SJC_SAMPLE_2[i][[1]][2]
      df.1$readCount_sample2_replicate3[i] <- df.1$IJC_SAMPLE_2[i][[1]][3] + df.1$SJC_SAMPLE_2[i][[1]][3]
      df.1$readCount_sample2_replicate4[i] <- df.1$IJC_SAMPLE_2[i][[1]][4] + df.1$SJC_SAMPLE_2[i][[1]][4]
    }
    
    df.1$sample1_sufficient_count <- rowSums(df.1[,c(22:25)]>10)>=3
    df.1$sample2_sufficient_count <- rowSums(df.1[,c(26:29)]>10)>=3
    
    for(i in 1:dim(df.2)[1]) {
      df.2$readCount_sample1_replicate1[i] <- df.2$IJC_SAMPLE_1[i][[1]][1] + df.2$SJC_SAMPLE_1[i][[1]][1]
      df.2$readCount_sample1_replicate2[i] <- df.2$IJC_SAMPLE_1[i][[1]][2] + df.2$SJC_SAMPLE_1[i][[1]][2]
      df.2$readCount_sample1_replicate3[i] <- df.2$IJC_SAMPLE_1[i][[1]][3] + df.2$SJC_SAMPLE_1[i][[1]][3]
      df.2$readCount_sample1_replicate4[i] <- df.2$IJC_SAMPLE_1[i][[1]][4] + df.2$SJC_SAMPLE_1[i][[1]][4]
      
      df.2$readCount_sample2_replicate1[i] <- df.2$IJC_SAMPLE_2[i][[1]][1] + df.2$SJC_SAMPLE_2[i][[1]][1]
      df.2$readCount_sample2_replicate2[i] <- df.2$IJC_SAMPLE_2[i][[1]][2] + df.2$SJC_SAMPLE_2[i][[1]][2]
      df.2$readCount_sample2_replicate3[i] <- df.2$IJC_SAMPLE_2[i][[1]][3] + df.2$SJC_SAMPLE_2[i][[1]][3]
      df.2$readCount_sample2_replicate4[i] <- df.2$IJC_SAMPLE_2[i][[1]][4] + df.2$SJC_SAMPLE_2[i][[1]][4]
    }
    
    df.2$sample1_sufficient_count <- rowSums(df.2[,c(22:25)]>10)>=3
    df.2$sample2_sufficient_count <- rowSums(df.2[,c(26:29)]>10)>=3
    
    for(i in 1:dim(df.3)[1]) {
      df.3$readCount_sample1_replicate1[i] <- df.3$IJC_SAMPLE_1[i][[1]][1] + df.3$SJC_SAMPLE_1[i][[1]][1]
      df.3$readCount_sample1_replicate2[i] <- df.3$IJC_SAMPLE_1[i][[1]][2] + df.3$SJC_SAMPLE_1[i][[1]][2]
      df.3$readCount_sample1_replicate3[i] <- df.3$IJC_SAMPLE_1[i][[1]][3] + df.3$SJC_SAMPLE_1[i][[1]][3]
      df.3$readCount_sample1_replicate4[i] <- df.3$IJC_SAMPLE_1[i][[1]][4] + df.3$SJC_SAMPLE_1[i][[1]][4]
      
      df.3$readCount_sample2_replicate1[i] <- df.3$IJC_SAMPLE_2[i][[1]][1] + df.3$SJC_SAMPLE_2[i][[1]][1]
      df.3$readCount_sample2_replicate2[i] <- df.3$IJC_SAMPLE_2[i][[1]][2] + df.3$SJC_SAMPLE_2[i][[1]][2]
      df.3$readCount_sample2_replicate3[i] <- df.3$IJC_SAMPLE_2[i][[1]][3] + df.3$SJC_SAMPLE_2[i][[1]][3]
      df.3$readCount_sample2_replicate4[i] <- df.3$IJC_SAMPLE_2[i][[1]][4] + df.3$SJC_SAMPLE_2[i][[1]][4]
    }
    
    df.3$sample1_sufficient_count <- rowSums(df.3[,c(22:25)]>10)>=3
    df.3$sample2_sufficient_count <- rowSums(df.3[,c(26:29)]>10)>=3
    
    for(i in 1:dim(df.4)[1]) {
      df.4$readCount_sample1_replicate1[i] <- df.4$IJC_SAMPLE_1[i][[1]][1] + df.4$SJC_SAMPLE_1[i][[1]][1]
      df.4$readCount_sample1_replicate2[i] <- df.4$IJC_SAMPLE_1[i][[1]][2] + df.4$SJC_SAMPLE_1[i][[1]][2]
      df.4$readCount_sample1_replicate3[i] <- df.4$IJC_SAMPLE_1[i][[1]][3] + df.4$SJC_SAMPLE_1[i][[1]][3]
      df.4$readCount_sample1_replicate4[i] <- df.4$IJC_SAMPLE_1[i][[1]][4] + df.4$SJC_SAMPLE_1[i][[1]][4]
      
      df.4$readCount_sample2_replicate1[i] <- df.4$IJC_SAMPLE_2[i][[1]][1] + df.4$SJC_SAMPLE_2[i][[1]][1]
      df.4$readCount_sample2_replicate2[i] <- df.4$IJC_SAMPLE_2[i][[1]][2] + df.4$SJC_SAMPLE_2[i][[1]][2]
      df.4$readCount_sample2_replicate3[i] <- df.4$IJC_SAMPLE_2[i][[1]][3] + df.4$SJC_SAMPLE_2[i][[1]][3]
      df.4$readCount_sample2_replicate4[i] <- df.4$IJC_SAMPLE_2[i][[1]][4] + df.4$SJC_SAMPLE_2[i][[1]][4]
    }
    
    df.4$sample1_sufficient_count <- rowSums(df.4[,c(22:25)]>10)>=3
    df.4$sample2_sufficient_count <- rowSums(df.4[,c(26:29)]>10)>=3
    
    # Subset for events based on PValue; reads mapped; replicate consistency
    index <- which(df.1$PValue < 0.01 & abs(df.1$IncLevelDifference) > 0.15 # filter for events with PValue < 0.01 and untr_vs_wt PSI diff > 0.15
                   & df.1$count_IJC_SAMPLE_1 == 4 & df.1$count_SJC_SAMPLE_1 == 4 & df.1$count_IJC_SAMPLE_2 == 4 & df.1$count_SJC_SAMPLE_2 == 4 & df.1$count_IncLevel1 == 4 & df.1$count_IncLevel2 == 4 # filter for events with consistent number of replicates
                   & df.1$sample1_sufficient_count==TRUE & df.1$sample2_sufficient_count==TRUE) # filter for events with sufficient number of reads
    
    df.1.small <- df.1[index, ]
    
    index <- which(df.2$count_IJC_SAMPLE_1 == 4 & df.2$count_SJC_SAMPLE_1 == 4 & df.2$count_IJC_SAMPLE_2 == 4 & df.2$count_SJC_SAMPLE_2 == 4 & df.2$count_IncLevel1 == 4 & df.2$count_IncLevel2 == 4 & df.2$sample1_sufficient_count==TRUE & df.2$sample2_sufficient_count==TRUE)
    df.2.small <- df.2[index, ]
    
    index <- which(df.3$count_IJC_SAMPLE_1 == 4 & df.3$count_SJC_SAMPLE_1 == 4 & df.3$count_IJC_SAMPLE_2 == 4 & df.3$count_SJC_SAMPLE_2 == 4 & df.3$count_IncLevel1 == 4 & df.3$count_IncLevel2 == 4 & df.3$sample1_sufficient_count==TRUE & df.3$sample2_sufficient_count==TRUE)
    df.3.small <- df.3[index, ]
    
    index <- which(df.4$count_IJC_SAMPLE_1 == 4 & df.4$count_SJC_SAMPLE_1 == 4 & df.4$count_IJC_SAMPLE_2 == 4 & df.4$count_SJC_SAMPLE_2 == 4 & df.4$count_IncLevel1 == 4 & df.4$count_IncLevel2 == 4 & df.4$sample1_sufficient_count==TRUE & df.4$sample2_sufficient_count==TRUE)
    df.4.small <- df.4[index, ]
    

    # Subset events appeared in all 4 tables
    overlap <- intersect(df.1.small$Event_ID, df.2$Event_ID)
    
    df.1.small <- df.1.small[which(df.1.small$Event_ID %in% overlap), ]
    df.2.small <- df.2[which(df.2$Event_ID %in% overlap), ]
    
    overlap <- intersect(df.1.small$Event_ID, df.3$Event_ID)
    df.1.small <- df.1.small[which(df.1.small$Event_ID %in% overlap), ]
    df.2.small <- df.2[which(df.2$Event_ID %in% overlap), ]
    df.3.small <- df.3[which(df.3$Event_ID %in% overlap), ]
    
    overlap <- intersect(df.1.small$Event_ID, df.4$Event_ID)
    df.1.small <- df.1.small[which(df.1.small$Event_ID %in% overlap), ]
    df.2.small <- df.2[which(df.2$Event_ID %in% overlap), ]
    df.3.small <- df.3[which(df.3$Event_ID %in% overlap), ]
    df.4.small <- df.4[which(df.4$Event_ID %in% overlap), ]
    
# Record individual PSI value; compute mean PSI    
    # Record individual replicates
    for(i in 1:dim(df.1.small)[1]) {
      df.1.small$PSI_sample1_replicate1[i] <- df.1.small$IncLevel1[[i]][1]
      df.1.small$PSI_sample1_replicate2[i] <- df.1.small$IncLevel1[[i]][2]
      df.1.small$PSI_sample1_replicate3[i] <- df.1.small$IncLevel1[[i]][3]
      df.1.small$PSI_sample1_replicate4[i] <- df.1.small$IncLevel1[[i]][4]
      
      df.1.small$PSI_sample2_replicate1[i] <- df.1.small$IncLevel2[[i]][1]
      df.1.small$PSI_sample2_replicate2[i] <- df.1.small$IncLevel2[[i]][2]
      df.1.small$PSI_sample2_replicate3[i] <- df.1.small$IncLevel2[[i]][3]
      df.1.small$PSI_sample2_replicate4[i] <- df.1.small$IncLevel2[[i]][4]
    }
    
    for(i in 1:dim(df.2.small)[1]) {
      df.2.small$PSI_sample1_replicate1[i] <- df.2.small$IncLevel1[[i]][1]
      df.2.small$PSI_sample1_replicate2[i] <- df.2.small$IncLevel1[[i]][2]
      df.2.small$PSI_sample1_replicate3[i] <- df.2.small$IncLevel1[[i]][3]
      df.2.small$PSI_sample1_replicate4[i] <- df.2.small$IncLevel1[[i]][4]
      
      df.2.small$PSI_sample2_replicate1[i] <- df.2.small$IncLevel2[[i]][1]
      df.2.small$PSI_sample2_replicate2[i] <- df.2.small$IncLevel2[[i]][2]
      df.2.small$PSI_sample2_replicate3[i] <- df.2.small$IncLevel2[[i]][3]
      df.2.small$PSI_sample2_replicate4[i] <- df.2.small$IncLevel2[[i]][4]
    }
    
    for(i in 1:dim(df.3.small)[1]) {
      df.3.small$PSI_sample1_replicate1[i] <- df.3.small$IncLevel1[[i]][1]
      df.3.small$PSI_sample1_replicate2[i] <- df.3.small$IncLevel1[[i]][2]
      df.3.small$PSI_sample1_replicate3[i] <- df.3.small$IncLevel1[[i]][3]
      df.3.small$PSI_sample1_replicate4[i] <- df.3.small$IncLevel1[[i]][4]
      
      df.3.small$PSI_sample2_replicate1[i] <- df.3.small$IncLevel2[[i]][1]
      df.3.small$PSI_sample2_replicate2[i] <- df.3.small$IncLevel2[[i]][2]
      df.3.small$PSI_sample2_replicate3[i] <- df.3.small$IncLevel2[[i]][3]
      df.3.small$PSI_sample2_replicate4[i] <- df.3.small$IncLevel2[[i]][4]
    }
    
    for(i in 1:dim(df.4.small)[1]) {
      df.4.small$PSI_sample1_replicate1[i] <- df.4.small$IncLevel1[[i]][1]
      df.4.small$PSI_sample1_replicate2[i] <- df.4.small$IncLevel1[[i]][2]
      df.4.small$PSI_sample1_replicate3[i] <- df.4.small$IncLevel1[[i]][3]
      df.4.small$PSI_sample1_replicate4[i] <- df.4.small$IncLevel1[[i]][4]
      
      df.4.small$PSI_sample2_replicate1[i] <- df.4.small$IncLevel2[[i]][1]
      df.4.small$PSI_sample2_replicate2[i] <- df.4.small$IncLevel2[[i]][2]
      df.4.small$PSI_sample2_replicate3[i] <- df.4.small$IncLevel2[[i]][3]
      df.4.small$PSI_sample2_replicate4[i] <- df.4.small$IncLevel2[[i]][4]
    }
    
    # Calculate mean PSI
    df.1.small$mean_PSI_sample1 <- lapply(df.1.small$IncLevel1, mean)
    df.1.small$mean_PSI_sample2 <- lapply(df.1.small$IncLevel2, mean)
    df.1.small$mean_PSI_sample1 <- as.numeric(df.1.small$mean_PSI_sample1)
    df.1.small$mean_PSI_sample2 <- as.numeric(df.1.small$mean_PSI_sample2)
    
    df.2.small$mean_PSI_sample1 <- lapply(df.2.small$IncLevel1, mean)
    df.2.small$mean_PSI_sample2 <- lapply(df.2.small$IncLevel2, mean)
    df.2.small$mean_PSI_sample1 <- as.numeric(df.2.small$mean_PSI_sample1)
    df.2.small$mean_PSI_sample2 <- as.numeric(df.2.small$mean_PSI_sample2)
    
    df.3.small$mean_PSI_sample1 <- lapply(df.3.small$IncLevel1, mean)
    df.3.small$mean_PSI_sample2 <- lapply(df.3.small$IncLevel2, mean)
    df.3.small$mean_PSI_sample1 <- as.numeric(df.3.small$mean_PSI_sample1)
    df.3.small$mean_PSI_sample2 <- as.numeric(df.3.small$mean_PSI_sample2)

    df.4.small$mean_PSI_sample1 <- lapply(df.4.small$IncLevel1, mean)
    df.4.small$mean_PSI_sample2 <- lapply(df.4.small$IncLevel2, mean)
    df.4.small$mean_PSI_sample1 <- as.numeric(df.4.small$mean_PSI_sample1)
    df.4.small$mean_PSI_sample2 <- as.numeric(df.4.small$mean_PSI_sample2)
    
    # Calculate delta PSI
    df.1.small$delta.PSI <- df.1.small$mean_PSI_sample1 - df.1.small$mean_PSI_sample2
    df.2.small$delta.PSI <- df.2.small$mean_PSI_sample1 - df.2.small$mean_PSI_sample2
    df.3.small$delta.PSI <- df.3.small$mean_PSI_sample1 - df.3.small$mean_PSI_sample2
    df.4.small$delta.PSI <- df.4.small$mean_PSI_sample1 - df.4.small$mean_PSI_sample2
    
# Make smaller data frames
df.1.small <- df.1.small[, c("Event_ID", "geneSymbol", "Event_type", "FDR", "IncLevel1", "IncLevel2", "mean_PSI_sample1", "mean_PSI_sample2", "IncLevelDifference", "delta.PSI")]
df.2.small <- df.2.small[, c("Event_ID", "geneSymbol", "Event_type", "FDR", "IncLevel1", "IncLevel2", "mean_PSI_sample1", "mean_PSI_sample2", "IncLevelDifference", "delta.PSI")]
df.3.small <- df.3.small[, c("Event_ID", "geneSymbol", "Event_type", "FDR", "IncLevel1", "IncLevel2", "mean_PSI_sample1", "mean_PSI_sample2", "IncLevelDifference", "delta.PSI")]
df.4.small <- df.4.small[, c("Event_ID", "geneSymbol", "Event_type", "FDR", "IncLevel1", "IncLevel2", "mean_PSI_sample1", "mean_PSI_sample2", "IncLevelDifference", "delta.PSI")]
    
# Indicate complete reversal
    # Nusinersen only
    index <- abs(df.2.small$IncLevelDifference) < 0.15
    sum(index)
    df.2.small$reversed <- ifelse(index, "yes", "no/partial")
    
    # MS023 only
    index <- abs(df.4.small$IncLevelDifference) < 0.15
    sum(index)
    df.4.small$reversed <- ifelse(index, "yes", "no/partial")
    
    # Nusinersen + MS023
    index <- abs(df.3.small$IncLevelDifference) < 0.15
    sum(index)
    df.3.small$reversed <- ifelse(index, "yes", "no/partial")
    
      # Find events uncorrected with Nusinersen only and MS023 only
    # Event_IDs_1 <- df.2.small[which(df.2.small$reversed=="no/partial"), "Event_ID"]
    # Event_IDs_2 <- df.4.small[which(df.4.small$reversed=="no/partial"), "Event_ID"]
    
      # Find events corrected with Nuninersen+MS023, but not each drugs individually
    # index <- which(df.3.small$reversed == "yes" & df.3.small$Event_ID %in% Event_IDs_1 & df.3.small$Event_ID %in% Event_IDs_2)
    # Event_IDs <- df.3.small[index, "Event_ID"]
      
      # Label events corrected only with Nusinersen+MS023 
    # if(length(Event_IDs) != 0) {
        
    #   df.3.small$reversed[which(df.3.small$Event_ID %in% Event_IDs)] <- "yes, in combination only"
        
    # }
    
      # Name the unique events
    # df.3.small$labels <- ifelse(df.3.small$Event_ID %in% Event_IDs, df.3.small$geneSymbol, "")
      
    # Set factor level
    levels <- intersect(c("yes", "no/partial"), unique(df.2.small$reversed))
    df.2.small$reversed <- factor(df.2.small$reversed, levels=levels)
    
    levels <- intersect(c("yes", "yes, in combination only", "no/partial"), unique(df.3.small$reversed))
    df.3.small$reversed <- factor(df.3.small$reversed, levels=levels)
    
    levels <- intersect(c("yes", "no/partial"), unique(df.4.small$reversed))
    df.4.small$reversed <- factor(df.4.small$reversed, levels=levels)
    
# Responding to Ania's request 06/07/2022
    # make smaller dataframe on Nusinersen and on Nusinersen+MS023
    df.2.smaller <- df.2.small[, c("Event_ID", "geneSymbol", "Event_type", "reversed")]
    df.3.smaller <- df.3.small[, c("Event_ID", "geneSymbol", "Event_type", "reversed")]
    
    # change column name
    names(df.2.smaller)[names(df.2.smaller) == "reversed"] <- "Nus.reversed"
    names(df.3.smaller)[names(df.3.smaller) == "reversed"] <- "Nus.MS023.reversed"
    
    # merge the two dataframe
    df.2.3.smaller <- merge(df.2.smaller, df.3.smaller, by=c("Event_ID", "geneSymbol", "Event_type"))
    
    # index the events
    index.both <- df.2.3.smaller$Nus.reversed == "yes" & df.2.3.smaller$Nus.MS023.reversed == "yes"
    sum(index.both)
    
    index.nus <- df.2.3.smaller$Nus.reversed == "yes" & df.2.3.smaller$Nus.MS023.reversed == "no/partial"
    sum(index.nus)
    
    index.nus.ms023 <- df.2.3.smaller$Nus.reversed == "no/partial" & df.2.3.smaller$Nus.MS023.reversed == "yes"
    sum(index.nus.ms023)
    
    # label the events
    df.2.3.smaller$reversed <- ifelse(index.both, "both", "no/partial")
    df.2.3.smaller$reversed[which(index.nus)] <- "nus only"
    df.2.3.smaller$reversed[which(index.nus.ms023)] <- "nus-ms023"
    
    levels <- intersect(c("both", "nus only", "nus-ms023", "no/partial"), unique(df.2.3.smaller$reversed))
    df.2.3.smaller$reversed <- factor(df.2.3.smaller$reversed, levels=levels)
    
    # split based on event type
    df.2.3.smaller.SE <- df.2.3.smaller[df.2.3.smaller$Event_type == "SE",]
    df.2.3.smaller.A5SS <- df.2.3.smaller[df.2.3.smaller$Event_type == "A5SS",]
    df.2.3.smaller.A3SS <- df.2.3.smaller[df.2.3.smaller$Event_type == "A3SS",]
    df.2.3.smaller.MXE <- df.2.3.smaller[df.2.3.smaller$Event_type == "MXE",]
    df.2.3.smaller.RI <- df.2.3.smaller[df.2.3.smaller$Event_type == "RI",]
    
    
###############################################################
######################## SCATTERPLOT ##########################
###############################################################
    
# Scatterplot: Untreated vs WT
# Definition
data <- df.1.small
x <- data$mean_PSI_sample1
y <- data$mean_PSI_sample2
maintitle <- ""
xtitle <- ""
ytitle <- ""
    
xmin <- 0 ; xmax <- 1 ; xinterval <- 0.25
ymin <- 0 ; ymax <- 1 ; yinterval <- 0.25
    
# Plot
plot <- ggplot() +
  geom_point(data, mapping=aes(x=x, y=y), color="#BBBBBB", size=3.0, alpha=0.7) +
  geom_abline(intercept=c(-0.15, 0.15), size=1.0, linetype="dashed", color="#CC3311") +
  #geom_text_repel(data, mapping=aes(x=x, y=y, label=label), max.overlaps = Inf, box.padding = 1.0, size=2, max.time = 1, max.iter = 1e5, segment.alpha=0.5, segment.size=0.1, min.segment.length = 0) +
  scale_x_continuous(breaks=seq(xmin, xmax, by=xinterval), limits=c(xmin, xmax)) +
  scale_y_continuous(breaks=seq(ymin, ymax, by=yinterval), limits=c(ymin, ymax)) +
  scale_fill_manual(values=colors) +
  labs(title=maintitle, x=xtitle, y=ytitle) +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        panel.border=element_blank(),
        plot.title=element_text(size=10, hjust=0.5),
        axis.line=element_line(colour = "black", size=2.0),
        axis.ticks.length=unit(0.25, "cm"),
        axis.title=element_text(size=10),
        axis.text=element_text(size=36, colour="black")
  )
    



    
# Scatterplot: nusinersen vs control
# Definition
data <- df.2.small
x <- data$mean_PSI_sample1
y <- data$mean_PSI_sample2
z <- data$reversed
maintitle <- ""
xtitle <- ""
ytitle <- ""
legendtitle <- "PSI Reversed"
    
xmin <- 0 ; xmax <- 1 ; xinterval <- 0.25
ymin <- 0 ; ymax <- 1 ; yinterval <- 0.25
    
# Color scheme
color.df <- data.frame("reversed"=c("no/partial", "yes"),
                           "color"=c("#009988", "#BBBBBB"),
                           stringsAsFactors=FALSE
)

colors <- color.df[which(color.df$reversed %in% levels(z)), "color"]
    
# Plot
plot <- ggplot() +
  geom_point(data, mapping=aes(x=x, y=y, color=z), size=3.0, alpha=0.7) +
  geom_abline(intercept=c(-0.15, 0.15), size=1.0, linetype="dashed", color="#CC3311") +
  scale_color_manual(values=colors) +
  #geom_text_repel(data, mapping=aes(x=x, y=y, label=label), max.overlaps = Inf, box.padding = 1.0, size=2, max.time = 1, max.iter = 1e5, segment.alpha=0.5, segment.size=0.1, min.segment.length = 0) +
  scale_x_continuous(breaks=seq(xmin, xmax, by=xinterval), limits=c(xmin, xmax)) +
  scale_y_continuous(breaks=seq(ymin, ymax, by=yinterval), limits=c(ymin, ymax)) +
  labs(title=maintitle, x=xtitle, y=ytitle, color=legendtitle) +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        panel.border=element_blank(),
        plot.title=element_text(size=10, hjust=0.5),
        axis.line=element_line(colour = "black", size=2.0),
        axis.ticks.length=unit(0.25, "cm"),
        axis.title=element_text(size=10),
        axis.text=element_text(size=36, colour="black"),
        legend.position="none",
        legend.title=element_text(size=8),
        legend.text=element_text(size=8),
        legend.key = element_blank()
  ) +
  guides(color = guide_legend(override.aes=list(size=2)))
    
    


# Scatterplot: nusinersen+MS023 vs control
# Definition
data <- df.3.small
x <- data$mean_PSI_sample1
y <- data$mean_PSI_sample2
z <- data$reversed
maintitle <- ""
xtitle <- ""
ytitle <- ""
legendtitle <- "PSI Reversed"
labels <- df.3.small$labels
    
xmin <- 0 ; xmax <- 1 ; xinterval <- 0.25
ymin <- 0 ; ymax <- 1 ; yinterval <- 0.25
    
# Color scheme
color.df <- data.frame("reversed"=c("no/partial", "yes", "yes, in combination only"),
                       "color"=c("#009988", "#EE7733", "#BBBBBB"),
                       stringsAsFactors=FALSE
)

colors <- color.df[which(color.df$reversed %in% levels(z)), "color"]
    
# Plot
plot <- ggplot() +
  geom_point(data, mapping=aes(x=x, y=y, color=z), size=3.0, alpha=0.7) +
  geom_abline(intercept=c(-0.15, 0.15), size=1.0, linetype="dashed", color="#CC3311") +
  scale_color_manual(values=colors) +
  geom_text_repel(data, mapping=aes(x=x, y=y, label=labels), max.overlaps = Inf, box.padding = 1.0, size=2, max.time = 1, max.iter = 1e5, segment.alpha=0.5, segment.size=0.1, min.segment.length = 0) +
  scale_x_continuous(breaks=seq(xmin, xmax, by=xinterval), limits=c(xmin, xmax)) +
  scale_y_continuous(breaks=seq(ymin, ymax, by=yinterval), limits=c(ymin, ymax)) +
  labs(title=maintitle, x=xtitle, y=ytitle, color=legendtitle) +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        panel.border=element_blank(),
        plot.title=element_text(size=10, hjust=0.5),
        axis.line=element_line(colour = "black", size=2.0),
        axis.ticks.length=unit(0.25, "cm"),
        axis.title=element_text(size=10),
        axis.text=element_text(size=36, colour="black"),
        legend.position="none",
        legend.title=element_text(size=8),
        legend.text=element_text(size=8),
        legend.key = element_blank()
  ) +
  guides(color = guide_legend(override.aes=list(size=2)))
    


# Scatterplot: MS023 vs control
# Definition
data <- df.4.small
x <- data$mean_PSI_sample1
y <- data$mean_PSI_sample2
z <- data$reversed
maintitle <- ""
xtitle <- ""
ytitle <- ""
legendtitle <- "PSI Reversed"

xmin <- 0 ; xmax <- 1 ; xinterval <- 0.25
ymin <- 0 ; ymax <- 1 ; yinterval <- 0.25
  
# Color scheme
color.df <- data.frame("reversed"=c("no/partial", "yes"),
                       "color"=c("#009988", "#BBBBBB"),
                       stringsAsFactors=FALSE
)

colors <- color.df[which(color.df$reversed %in% levels(z)), "color"]

# Plot
plot <- ggplot() +
  geom_point(data, mapping=aes(x=x, y=y, color=z), size=3.0, alpha=0.7) +
  geom_abline(intercept=c(-0.15, 0.15), size=1.0, linetype="dashed", color="#CC3311") +
  scale_color_manual(values=colors) +
  #geom_text_repel(data, mapping=aes(x=x, y=y, label=label), max.overlaps = Inf, box.padding = 1.0, size=2, max.time = 1, max.iter = 1e5, segment.alpha=0.5, segment.size=0.1, min.segment.length = 0) +
  scale_x_continuous(breaks=seq(xmin, xmax, by=xinterval), limits=c(xmin, xmax)) +
  scale_y_continuous(breaks=seq(ymin, ymax, by=yinterval), limits=c(ymin, ymax)) +
  labs(title=maintitle, x=xtitle, y=ytitle, color=legendtitle) +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        panel.border=element_blank(),
        plot.title=element_text(size=10, hjust=0.5),
        axis.line=element_line(colour = "black", size=2.0),
        axis.ticks.length=unit(0.25, "cm"),
        axis.title=element_text(size=10),
        axis.text=element_text(size=36, colour="black"),
        legend.position="none",
        legend.title=element_text(size=8),
        legend.text=element_text(size=8),
        legend.key = element_blank()
  ) +
      guides(color = guide_legend(override.aes=list(size=2)))