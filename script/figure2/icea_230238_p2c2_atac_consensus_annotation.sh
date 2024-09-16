#!/bin/bash
source /opt/anaconda3/bin/activate ICE_A_env
icea_path="/mnt/data/bioinfo_tools_and_refs/bioinfo_tools/ICE_A/ICE_A.nf"
proj_dir="/mnt/data/common/tobias/tg/ICE_A/ICEA_analysis"
run_dir=$proj_dir/output/data/figure2/annotation
peaks=$run_dir/atac_230238_p2c2_consensus_peak_info.txt
bed2D_230238=$proj_dir/data/interactions/230238_H3K4me3_FitHiChIP.interactions_FitHiC_Q0.05_MergeNearContacts.bed
bed2D_p2c2=$proj_dir/data/interactions/P2C2_H3K4me3_FitHiChIP.interactions_FitHiC_Q0.05_MergeNearContacts.bed
bed2D_p2c2_alltoall=$proj_dir/data/interactions/P2C2_H3K4me3_FitHiChIP_ALL2ALL.interactions_FitHiC_Q0.05_MergeNearContacts.bed
outdir_230238="atac_230238_p2c2_consensus_peaks_230238_H3K4me3_PLAC_annotation"
outdir_p2c2="atac_230238_p2c2_consensus_peaks_P2C2_H3K4me3_PLAC_annotation"
outdir_p2c2_alltoall="atac_230238_p2c2_consensus_peaks_P2C2_H3K4me3_PLAC_annotation_alltoall"
cd $run_dir

#230238
echo nextflow run $icea_path --peaks $peaks --bed2D $bed2D_230238 --genome mm10 --outdir $outdir_230238 --close_peak_type distance --close_peak_distance 5000 --close_promoter_type distance --close_promoter_distance_start 5000 --close_promoter_distance_end 5000 --filter_close sum --multiple_anno keep --skip_promoter_promoter -ansi-log false
#nextflow run $icea_path --peaks $peaks --bed2D $bed2D_230238 --genome mm10 --outdir $outdir_230238 --close_peak_type distance --close_peak_distance 5000 --close_promoter_type distance --close_promoter_distance_start 5000 --close_promoter_distance_end 5000 --filter_close sum --multiple_anno keep --skip_promoter_promoter -ansi-log false

#P2C2 (Annotate interaction for figure 4)
echo nextflow run $icea_path --peaks $peaks --bed2D $bed2D_p2c2 --genome mm10 --outdir $outdir_p2c2 --close_peak_type distance --close_peak_distance 5000 --close_promoter_type distance --close_promoter_distance_start 5000 --close_promoter_distance_end 5000 --filter_close sum --multiple_anno keep --skip_promoter_promoter --annotate_interactions -ansi-log false
#nextflow run $icea_path --peaks $peaks --bed2D $bed2D_p2c2 --genome mm10 --outdir $outdir_p2c2 --close_peak_type distance --close_peak_distance 5000 --close_promoter_type distance --close_promoter_distance_start 5000 --close_promoter_distance_end 5000 --filter_close sum --multiple_anno keep --skip_promoter_promoter --annotate_interactions -ansi-log false

#P2C2 ALL-to-ALL (to macth WT/EKO plac for fig 4)
echo nextflow run $icea_path --peaks $peaks --bed2D $bed2D_p2c2_alltoall --genome mm10 --outdir $outdir_p2c2_alltoall --close_peak_type distance --close_peak_distance 5000 --close_promoter_type distance --close_promoter_distance_start 5000 --close_promoter_distance_end 5000 --filter_close sum --multiple_anno keep --skip_promoter_promoter --annotate_interactions -ansi-log false
nextflow run $icea_path --peaks $peaks --bed2D $bed2D_p2c2_alltoall --genome mm10 --outdir $outdir_p2c2_alltoall --close_peak_type distance --close_peak_distance 5000 --close_promoter_type distance --close_promoter_distance_start 5000 --close_promoter_distance_end 5000 --filter_close sum --multiple_anno keep --skip_promoter_promoter --annotate_interactions -ansi-log false

