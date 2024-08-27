#!/bin/bash
source /opt/anaconda3/bin/activate ICE_A_env
icea_path="/mnt/data/bioinfo_tools_and_refs/bioinfo_tools/ICE_A/ICE_A.nf"
proj_dir="/mnt/data/common/tobias/tg/ICE_A/ICEA_analysis"
run_dir=$proj_dir/output/data/figure3/annotation
peaks_ebf1=$run_dir/atac_FLproB_WT_EKO_peaks.txt
bed2D_WT=$proj_dir/data/interactions/21_174_175_H3K4me3_FLWT_5kb_ALL2ALL.interactions_FitHiC_Q0.05_MergeNearContacts.bed
bed2D_EKO=$proj_dir/data/interactions/13_16_176_177_H3K4me3_FLEKO_5kb_ALL2ALL.interactions_FitHiC_Q0.05_MergeNearContacts.bed
outdir_WT="atac_FLproB_WT_H3K4me3_PLACseq_annotation"
outdir_EKO="atac_FLproB_Ebf1KO_H3K4me3_PLACseq_annotation"

cd $run_dir
echo nextflow run $icea_path --peaks $peaks_ebf1 --bed2D $bed2D_WT --genome mm10 --outdir $outdir_WT  --close_peak_type distance --close_peak_distance 5000 --close_promoter_type distance --close_promoter_distance_start 5000 --close_promoter_distance_end 5000 --filter_close sum --multiple_anno keep --skip_promoter_promoter -ansi-log false
nextflow run $icea_path --peaks $peaks_ebf1 --bed2D $bed2D_WT --genome mm10 --outdir $outdir_WT --close_peak_type distance --close_peak_distance 5000 --close_promoter_type distance --close_promoter_distance_start 5000 --close_promoter_distance_end 5000 --filter_close sum --multiple_anno keep --skip_promoter_promoter -ansi-log false

echo nextflow run $icea_path --peaks $peaks_ebf1 --bed2D $bed2D_EKO --genome mm10 --outdir $outdir_EKO  --close_peak_type distance --close_peak_distance 5000 --close_promoter_type distance --close_promoter_distance_start 5000 --close_promoter_distance_end 5000 --filter_close sum --multiple_anno keep --skip_promoter_promoter -ansi-log false
nextflow run $icea_path --peaks $peaks_ebf1 --bed2D $bed2D_EKO --genome mm10 --outdir $outdir_EKO --close_peak_type distance --close_peak_distance 5000 --close_promoter_type distance --close_promoter_distance_start 5000 --close_promoter_distance_end 5000 --filter_close sum --multiple_anno keep --skip_promoter_promoter -ansi-log false
