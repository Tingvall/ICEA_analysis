DESeq2_fun <- function(counts, coldata, selection, factor, groups,plotMA=TRUE, name=FALSE, result=TRUE, mapID=FALSE, filt=TRUE, filt_n=FALSE, filt_value=10, coef=2, orgdb=FALSE){
  
  coldata[,factor] <- factor(coldata[,factor], levels=groups) #specify groups with ctrl first
  
  if (!name!=FALSE){
    name <- paste0("DE.",groups[2],"vs", groups[1])
  }
  
  # Creating DESeq2 count table of total reads 
  design <-  formula(paste("~",factor))
  
  if (filt){
    counts <- counts[rowSums(counts[,selection] >= filt_value) >= filt_n,]
  }
  
  DESeq2.count.table.total <- DESeqDataSetFromMatrix(
    countData = counts[,selection],
    colData = coldata[selection,],
    design = design)
  DESeq2 <- DESeq(DESeq2.count.table.total)
  assign(paste0(name, ".dds"),DESeq2, envir = .GlobalEnv)
  
  #Result
  contrast=c(factor, rev(groups))
  DESeq2.result <- results(DESeq2, contrast=contrast)
  assign(paste0(name, ".result"),DESeq2.result, envir = .GlobalEnv)
  DESeq2.result.df <- results(DESeq2, contrast=contrast, format = "DataFrame", tidy = T)
  
  DESeq2.result.lcfshr <- lfcShrink(DESeq2, coef = coef, type="apeglm")
  assign(paste0(name, ".result.lcfshr"),DESeq2.result.lcfshr, envir = .GlobalEnv)
  
  DESeq2.result.lcfshr.df <- data.frame(DESeq2.result.lcfshr@listData)
  colnames(DESeq2.result.lcfshr.df)[colnames(DESeq2.result.lcfshr.df)  %in% c("log2FoldChange", "lfcSE")] <- c("lfcShrink","lfcShrinkSE" )
  DESeq2.result.df.merge <- merge(DESeq2.result.df, DESeq2.result.lcfshr.df[,c(2,3)], by.x="row", by.y=0)
  DESeq2.result.df.merge <- DESeq2.result.df.merge[,c(1,2,3,4,8,9,5,6,7)]
  
  if (mapID){
    DESeq2.result.df.merge$symbol <- mapIds(orgdb,
                                            keys=DESeq2.result.df.merge[,1],
                                            column="SYMBOL",
                                            keytype="ENTREZID")
  }
  
  assign(paste0(name, ".result.df"),DESeq2.result.df.merge, envir = .GlobalEnv)
  
  if (plotMA){
    DESeq2::plotMA(DESeq2)
    DESeq2::plotMA(DESeq2.result.lcfshr)
  }
}



