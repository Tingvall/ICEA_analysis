#!/bin/bash
source /opt/anaconda3/bin/activate ICE_A_env
icea_path="/mnt/data/bioinfo_tools_and_refs/bioinfo_tools/ICE_A/ICE_A.nf"
proj_dir="/mnt/data/common/tobias/tg/ICE_A/ICEA_analysis"
run_dir=$proj_dir/output/data/figure4/annotation
peaks=$proj_dir/output/data/figure2/annotation/atac_230238_p2c2_consensus_peak_info.txt
bed2D_P2C2=$proj_dir/data/interactions/P2C2_H3K4me3_FitHiChIP.interactions_FitHiC_Q0.05_MergeNearContacts.bed
bed2D_WT=$proj_dir/data/interactions/21_174_175_H3K4me3_FLWT_5kb_ALL2ALL.interactions_FitHiC_Q0.05_MergeNearContacts.bed
bed2D_Ebf1KO=$proj_dir/data/interactions/13_16_176_177_H3K4me3_FLEKO_5kb_ALL2ALL.interactions_FitHiC_Q0.05_MergeNearContacts.bed
outdir_P2C2="Consensus_atac_P2C2_H3K4me3_PLAC_annotation_custom_TSS"
outdir_WT="Consensus_atac_WTproB_H3K4me3_PLAC_annotation_custom_TSS"
outdir_Ebf1KO="Consensus_atac_Ebf1KOproB_H3K4me3_PLAC_annotation_custom_TSS"
tss=$run_dir/custom_tss.txt

cd $run_dir

#P2C2
echo nextflow run $icea_path --peaks $peaks --bed2D $bed2D_P2C2 --genome mm10 --outdir $outdir_P2C2 --close_peak_type distance --close_peak_distance 5000 --close_promoter_type distance --close_promoter_distance_start 5000 --close_promoter_distance_end 5000 --filter_close sum --multiple_anno keep -ansi-log false --tss $tss
nextflow run $icea_path --peaks $peaks --bed2D $bed2D_P2C2 --genome mm10 --outdir $outdir_P2C2 --close_peak_type distance --close_peak_distance 5000 --close_promoter_type distance --close_promoter_distance_start 5000 --close_promoter_distance_end 5000 --filter_close sum --multiple_anno keep -ansi-log false --tss $tss
#WT
echo nextflow run $icea_path --peaks $peaks --bed2D $bed2D_WT --genome mm10 --outdir $outdir_WT --close_peak_type distance --close_peak_distance 5000 --close_promoter_type distance --close_promoter_distance_start 5000 --close_promoter_distance_end 5000 --filter_close sum --multiple_anno keep -ansi-log false --tss $tss
nextflow run $icea_path --peaks $peaks --bed2D $bed2D_WT --genome mm10 --outdir $outdir_WT --close_peak_type distance --close_peak_distance 5000 --close_promoter_type distance --close_promoter_distance_start 5000 --close_promoter_distance_end 5000 --filter_close sum --multiple_anno keep -ansi-log false --tss $tss

#Ebf1KO
echo nextflow run $icea_path --peaks $peaks --bed2D $bed2D_Ebf1KO --genome mm10 --outdir $outdir_Ebf1KO --close_peak_type distance --close_peak_distance 5000 --close_promoter_type distance --close_promoter_distance_start 5000 --close_promoter_distance_end 5000 --filter_close sum --multiple_anno keep -ansi-log false --tss $tss
nextflow run $icea_path --peaks $peaks --bed2D $bed2D_Ebf1KO --genome mm10 --outdir $outdir_Ebf1KO --close_peak_type distance --close_peak_distance 5000 --close_promoter_type distance --close_promoter_distance_start 5000 --close_promoter_distance_end 5000 --filter_close sum --multiple_anno keep -ansi-log false --tss $tss

