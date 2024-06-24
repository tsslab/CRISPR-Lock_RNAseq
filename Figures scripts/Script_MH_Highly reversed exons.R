index <- which(df.2.small$reversed == "yes" | df.2.small$reversed == "partial")

df.2.corrected <- df.2.small[index, ]

overlap <- intersect(df.2.corrected$tran_id, df.1.small$tran_id)

df.1.corrected <- df.1.small[which(df.1.small$tran_id %in% overlap), ]
# df.2.corrected <- df.2.corrected[which(df.2.small$tran_id %in% overlap), ]

df.2.corrected <- df.2.corrected[ , c("tran_id", "gene_short_name", "mean.g1", "mean.g2", "mean.diff", "reversed")]
df.1.corrected <- df.1.corrected[ , c("tran_id", "gene_short_name", "mean.g1", "mean.g2", "mean.diff")]

names(df.2.corrected)[3] <- 'mean.g1_df2'
names(df.2.corrected)[4] <- 'mean.g2_df2'
names(df.2.corrected)[5] <- 'mean.diff_df2'

names(df.1.corrected)[3] <- 'mean.g1_df1'
names(df.1.corrected)[4] <- 'mean.g2_df1'
names(df.1.corrected)[5] <- 'mean.diff_df1'

df.1.2.corrected <- merge(df.1.corrected, df.2.corrected, by="tran_id")

df.1.2.corrected$shift <- abs(df.1.2.corrected$mean.g2_df1 - df.1.2.corrected$mean.g2_df2)

# Save df.1.2.corrected table
. <- df.1.2.corrected
file <- "df.1.2.corrected"
path <- paste("C:/Users/Muhammad Hanifi/Downloads/mh_plots/", "/", sep="")
write.table(., paste(path, file, sep=""), sep="\t", col.names=TRUE, row.names=FALSE, quote=FALSE)
