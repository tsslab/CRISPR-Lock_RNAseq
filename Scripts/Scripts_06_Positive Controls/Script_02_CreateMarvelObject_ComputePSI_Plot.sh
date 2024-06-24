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
    path <- "/Users/seanwen/Documents/Hanifi/Positive Controls/"
    file <- "SE_featureData.txt"
    df.feature.se <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, na.strings="NA")
        
    # Merge into list
    df.feature.list <- list(df.feature.se)
    names(df.feature.list) <- c("SE")

#################################################################################
########################## CHECK ANKA COORDINATES ###############################
#################################################################################

# Retrieve coordinates
tran_id <- df.feature.se[which(df.feature.se$gene_short_name=="ANK2"), "tran_id"]
. <- strsplit(tran_id, split=":+@", fixed=TRUE)

# Subset chr
exon.1 <- sapply(., function(x) {x[1]})
chr <- sapply(strsplit(exon.1, ":"), function(x) {x[1]})

# Subset 5' included sj
exon.1 <- sapply(., function(x) {x[1]})
exon.2 <- sapply(., function(x) {x[2]})
start <- as.numeric(sapply(strsplit(exon.1, ":"), function(x) {x[3]})) + 1
end <- as.numeric(sapply(strsplit(exon.2, ":"), function(x) {x[2]})) - 1
coord.included.1 <- paste(chr, start, end, sep=":")

# Subset 3' included sj
exon.2 <- sapply(., function(x) {x[2]})
exon.3 <- sapply(., function(x) {x[3]})
start <- as.numeric(sapply(strsplit(exon.2, ":"), function(x) {x[3]})) + 1
end <- as.numeric(sapply(strsplit(exon.3, ":"), function(x) {x[2]})) - 1
coord.included.2 <- paste(chr, start, end, sep=":")

# Subset skipped sj
exon.1 <- sapply(., function(x) {x[1]})
exon.3 <- sapply(., function(x) {x[3]})
start <- as.numeric(sapply(strsplit(exon.1, ":"), function(x) {x[3]})) + 1
end <- as.numeric(sapply(strsplit(exon.3, ":"), function(x) {x[2]})) - 1
coord.excluded <- paste(chr, start, end, sep=":")

# Check if coordinates detected by STAR
which(sj$coord.intron==coord.included.1)
which(sj$coord.intron==coord.included.2)
which(sj$coord.intron==coord.excluded)

# Add dummry entry for excluded coordinate
sj.small <- sj["", ]
sj.small$coord.intron <- coord.excluded
sj <- rbind.data.frame(sj, sj.small)

#################################################################################
########################## CREATE MARVEL OBJECT #################################
#################################################################################

# Create MARVEL object
marvel <- CreateMarvelObject(SpliceJunction=sj,
                             SplicePheno=df.pheno,
                             SpliceFeature=df.feature.list
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

# Save MARVEL object
path <- "/Users/seanwen/Documents/Hanifi/Positive Controls/"
file <- "MARVEL.RData"
save(marvel, file=paste(path, file, sep=""))

#################################################################################
########################### PLOT: MARVEL-VIOLIN #################################
#################################################################################

# Check groups
table(df.pheno$group)

# Define groups to plot
cell.type.columns <- list(c("group"), c("group"), c("group"),
                          c("group"), c("group"), c("group"),
                          c("group"), c("group"), c("group")
                          )

cell.type.variables <- list(list("WT untreated"),
                            list("DM1 untreated"),
                            list("WT ASO placebo"),
                            list("DM1 ASO placebo"),
                            list("DM1 ASO low dose treatment"),
                            list("DM1 ASO high dose treatment"),
                            list("WT dCas13 placebo"),
                            list("DM1 dCas13 placebo"),
                            list("DM1 dCas13 treated")
                            )

cell.type.labels <- c("WT\nuntreated",
                      "DM1\nuntreated",
                      "WT\nASO\nplacebo",
                      "DM1\nASO\nplacebo",
                      "DM1\nASO\nlow\ndose",
                      "DM1\nASO\nhigh\ndose",
                      "WT\ndCas13\nplacebo",
                      "DM1\ndCas13\nplacebo",
                      "DM1\ndCas13\ntreated"
                      )


# Define tran_ids
df.feature <- marvel$SpliceFeatureValidated$SE
tran_ids <- df.feature$tran_id

# Violin plot
marvel <- PlotValues(MarvelObject=marvel,
                     cell.type.columns=cell.type.columns,
                     cell.type.variables=cell.type.variables,
                     cell.type.labels=cell.type.labels,
                     feature=tran_ids[1],
                     xlabels.size=5,
                     level="splicing",
                     min.cells=0,
                     bimodal.adjust=TRUE,
                     seed=1,
                     max.cells.jitter=50,
                     max.cells.jitter.seed=1
                     )

marvel$adhocPlot$PSI # ASO & dCas13 reverse PSI to WT profile
                     # ASO high > low effect

#################################################################################
########################## PLOT: CUSTOM DOTPLOT #################################
#################################################################################

# Retrieve data
    # PSI matrix
    df <- marvel$PSI$SE
    
    # featureData
    df.feature <- marvel$SpliceFeatureValidated$SE
    
    # phenoData
    df.pheno <- marvel$SplicePheno

# Dotplot
tran_ids <- df.feature$tran_id
gene_short_names <- df.feature$gene_short_name

for(i in 1:length(tran_ids)) {

    # Subset PSI values
    . <- df[which(df$tran_id==tran_ids[i]), ]
    . <- .[,-1]
    . <- as.data.frame(t(.))
    names(.) <- "psi"
    .$sample.id <- row.names(.)
    row.names(.) <- NULL
    . <- .[,c("sample.id", "psi")]
    results <- .
    
    # Annotate sample group
    results <- join(results, df.pheno[,c("sample.id", "group")], by="sample.id", type="left")
    
    # Set factor levels
    table(results$group)
    levels <- c("WT untreated",
                "DM1 untreated",
                "WT ASO placebo",
                "DM1 ASO placebo",
                "DM1 ASO low dose treatment",
                "DM1 ASO high dose treatment",
                "WT dCas13 placebo",
                "DM1 dCas13 placebo",
                "DM1 dCas13 treated"
                )
                
    labels <- c("WT untreated",
                "DM1 untreated",
                "WT ASO placebo",
                "DM1 ASO placebo",
                "DM1 ASO low",
                "DM1 ASO high",
                "WT dCas13 placebo",
                "DM1 dCas13 placebo",
                "DM1 dCas13 treated"
                )
                
    results$group <- factor(results$group, levels=levels, labels=labels)
        
    # Dotplot
    data <- results
    x <- data$group
    y <- data$psi
    z <- data$group
    maintitle <- gene_short_names[i]
    ytitle <- "PSI"
    xtitle <- ""
    #xlabels <- n.cells$label


    # Plot
    plot <- ggplot() +
        geom_jitter(data, mapping=aes(x=x, y=y, fill=z), position=position_jitter(width=0.1, height=0), color="black", pch=21, size=3, alpha=0.50, stroke=0.1) +
        stat_summary(data, mapping=aes(x=x, y=y), geom="crossbar", fun="mean", color="red", size=0.25, width=0.5) +
        #scale_fill_manual(values=cols) +
        #scale_x_discrete(labels=xlabels) +
        scale_y_continuous(breaks=seq(0, 1, by=0.25), limits=c(0, 1)) +
        labs(title=maintitle, x=xtitle, y=ytitle) +
        theme(panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            panel.background = element_blank(),
            panel.border=element_blank(),
            plot.title=element_text(hjust = 0.5, size=12),
            plot.subtitle=element_text(hjust = 0.5, size=12),
            axis.line.y.left = element_line(color="black"),
            axis.line.x = element_line(color="black"),
            axis.title=element_text(size=10),
            axis.text=element_text(size=10),
            axis.text.x=element_text(size=6, colour="black", angle=45, hjust=1, vjust=1),
            axis.text.y=element_text(size=10, colour="black"),
            legend.position="none",
            legend.title=element_text(size=10),
            legend.text=element_text(size=10)
            )
    
    # Save file
    path <- "/Users/seanwen/Documents/Hanifi/Positive Controls/Plots/"
    file <- paste(gene_short_names[i], ".pdf", sep="")
    ggsave(paste(path, file, sep=""), plot, width=4, height=4)

}
