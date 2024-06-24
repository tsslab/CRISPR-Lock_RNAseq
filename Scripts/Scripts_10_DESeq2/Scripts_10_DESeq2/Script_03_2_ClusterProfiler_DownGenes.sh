# Load packages
library(org.Hs.eg.db)
library(GO.db)
library(clusterProfiler)
library(AnnotationDbi)

# Define DESeq2-Volcano plot files
path <- "/Users/seanwen/Documents/Hanifi/DESeq2/Tables_Filtered/"
files <- list.files(path)

pb <- txtProgressBar(1, length(files), style=3)
        
for(i in 1:length(files)) {

    # Read DE file
    path <- "/Users/seanwen/Documents/Hanifi/DESeq2/Tables_Filtered/"
    file <- files[i]
    df <- read.table(paste(path, file, sep=""), sep="\t", header=TRUE, stringsAsFactors=FALSE, quote="\"")
    
    # Subset up-regulated genes
    gene_short_names <- df[which(df$log2FoldChange < -0.10 & df$padj < 0.01), "gene_short_name"]
    length(gene_short_names)
    
    if(length(gene_short_names) >= 50) {
    
        # Retrieve entrez IDs
        ID <- AnnotationDbi::select(org.Hs.eg.db, keys=gene_short_names, columns=c("ENTREZID", "SYMBOL"), keytype="SYMBOL")
            
        # GO analysis
        ego <- enrichGO(ID$ENTREZID, OrgDb = "org.Hs.eg.db", ont="BP", readable=TRUE, pAdjustMethod="fdr", pvalueCutoff=0.05)
            
        # GO analysis (Remove redundant terms)
        ego2 <- simplify(ego, cutoff=0.7, by="p.adjust", select_fun=min)
        
        print(paste(sum(ego2$p.adjust < 0.01), " significant terms identified", sep=""))

        # Save files
        path <- "/Users/seanwen/Documents/Hanifi/DESeq2/ClusterProfiler/"
        file <- paste(gsub(".txt", "", files[i], fixed=TRUE), "_Down-regulated Genes.txt", sep="")
        write.table(ego2, paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)
        
    }
    
    # Track progress
    setTxtProgressBar(pb, i)

}
