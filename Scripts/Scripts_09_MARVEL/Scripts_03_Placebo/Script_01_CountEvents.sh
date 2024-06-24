# Load packages
library(MARVEL)
library(ggplot2)

# Load MARVEL object
path <- "/Users/seanwen/Documents/Hanifi/MARVEL/R Object/"
file <- "MARVEL.RData"
load(file=paste(path, file, sep=""))

#########################################################################

# Define cell groups
groups <- c("WT ASO placebo", "DM1 ASO placebo", "WT dCas13 placebo", "DM1 dCas13 placebo")

for(i in 1:length(groups)) {

    # Tabulate
    marvel <- CountEvents(MarvelObject=marvel,
                          cell.type.columns=c("group"),
                          cell.type.variables=list(c(groups[i])),
                          n.cells=3,
                          event.group.colors=NULL
                          )

    # Save plot
    path <- "/Users/seanwen/Documents/Hanifi/MARVEL/Pct Events/"
    file <- paste(groups[i], ".pdf", sep="")
    ggsave(paste(path, file, sep=""), marvel$N.Events$Plot, width=5, height=5)

    # Save file
    path <- "/Users/seanwen/Documents/Hanifi/MARVEL/Pct Events/"
    file <- paste(groups[i], ".txt", sep="")
    write.table(marvel$N.Events$Table, paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)
    
    # Track progress
    print(paste(groups[i], " tabulated", sep=""))

}
