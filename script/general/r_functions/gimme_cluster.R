gimme_cluster <- function(path, cutoff=4, cluster_row=T, cluster_col=T, family="", font.size=6){
  
  require(circlize)
  require(ComplexHeatmap)
  require(viridis)
  require(stringr)
  
  #Load data
  motif_clusters <- read.table(file=paste(path,"final.out.txt", sep=""), header = T, sep = "\t", quote = "")
  colnames(motif_clusters) <- str_replace(colnames(motif_clusters),
                                          pattern = "z.score.",
                                          replacement = "")
  motif_clusters <- motif_clusters[,1:(((ncol(motif_clusters)-1)/2)+1)]

  #Motif TFs
  m2f <- read.table(file=paste(path,"nonredundant.motifs.motif2factors.txt", sep=""), header = T, sep = "\t", quote = "")
  m2f <- m2f[m2f$Evidence=="JASPAR",]
  m2f <- m2f[,1:2]
  m2f$Factor <- toupper(m2f$Factor)
  m2f <- unique(m2f)
  m2f <- aggregate(Factor ~ Motif, m2f, paste, collapse = "/")
  motif_clusters <- merge(motif_clusters, m2f[, c("Motif", "Factor")], by.x = "X", by.y = "Motif", all.x=T)
  rownames(motif_clusters) <- motif_clusters$X
  motif_clusters <- motif_clusters[,2:ncol(motif_clusters)]
  motif_clusters[is.na(motif_clusters$Factor),"Factor"] <- rownames(motif_clusters[is.na(motif_clusters$Factor),])
  
  #filtering for motifs with a -log(p)>cutoff in at least one cluster
  motif_clusters.filt <- motif_clusters[rowSums(motif_clusters[1:(ncol(motif_clusters)-1)]>= cutoff)>0,]
  
  #heatmap
  col <-  colorRamp2(c(-5, 0, 5),c("#1F426A","white","#95302F"),space="RGB")
  gimme.hm <- Heatmap(as.matrix(motif_clusters.filt[,1:(ncol(motif_clusters)-1)]), name="motifs", row_labels = motif_clusters.filt$Factor, col=col,cluster_columns = cluster_col,
                      row_names_gp=gpar(fontfamily=family, fontsize=font.size),
                      column_names_gp=gpar(fontfamily=family, fontsize=font.size),
                      heatmap_legend_param = list(title="z-score",
                                                  title_gp=gpar(fontfamily=family, fontsize=font.size, fontface="bold"), 
                                                  direction = "horizontal", 
                                                  labels_gp=gpar(fontfamily=family, fontsize=font.size),at = c(-5, 0, 5) ))
  
  draw(gimme.hm, heatmap_legend_side = "bottom", padding = unit(c(0, 0, 0, 50), "mm"))
  #return(gimme.hm)
}


