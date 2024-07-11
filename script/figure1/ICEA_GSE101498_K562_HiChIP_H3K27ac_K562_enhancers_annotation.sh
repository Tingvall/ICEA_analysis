#!/bin/bash
source /opt/anaconda3/bin/activate ICE_A_env
icea_path="/mnt/data/bioinfo_tools_and_refs/bioinfo_tools/ICE_A/ICE_A.nf"
proj_dir="/mnt/data/common/tobias/tg/ICE_A/ICEA_analysis"
run_dir=$proj_dir/output/data/figure1/annotation
peaks=$run_dir/K562_enhancers_info.txt
bed2D=$proj_dir/data/interactions/GSE101498_K562_HiChIP_H3K27ac_FitHiChIP_v_9_1.interactions_FitHiC_Q0.05_MergeNearContacts.bed
outdir="K562_enhancers_HiChIP_H3K27ac_annotation"

cd $run_dir
echo nextflow run $icea_path --peaks $peaks --bed2D $bed2D --genome hg19 --outdir $outdir --close_peak_type distance --close_peak_distance 7500 --close_promoter_type distance --close_promoter_distance_start 7500 --close_promoter_distance_end 7500 --filter_close sum --multiple_anno keep --proximity_unannotated -ansi-log false
nextflow run $icea_path --peaks $peaks --bed2D $bed2D --genome hg19 --outdir $outdir --close_peak_type distance --close_peak_distance 7500 --close_promoter_type distance --close_promoter_distance_start 7500 --close_promoter_distance_end 7500 --filter_close sum --multiple_anno keep --proximity_unannotated -ansi-log false

