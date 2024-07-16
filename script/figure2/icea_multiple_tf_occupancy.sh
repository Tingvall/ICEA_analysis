#!/bin/bash
source /opt/anaconda3/bin/activate ICE_A_env
icea_path="/mnt/data/bioinfo_tools_and_refs/bioinfo_tools/ICE_A/ICE_A.nf"
proj_dir="/mnt/data/common/tobias/tg/ICE_A/ICEA_analysis"
run_dir=$proj_dir/output/data/figure2/tf_occupancy
peaks=$run_dir/tf_occupancy_BT_elements_info.txt
bed2D_230238=$proj_dir/data/interactions/230238_H3K4me3_FitHiChIP.interactions_FitHiC_Q0.05_MergeNearContacts.bed
bed2D_p2c2=$proj_dir/data/interactions/P2C2_H3K4me3_FitHiChIP.interactions_FitHiC_Q0.05_MergeNearContacts.bed
outdir_B="tf_occupancy_Bgenes_230238_H3K4me3_PLAC_annotation"
outdir_T="tf_occupancy_Tgenes_P2C2_H3K4me3_PLAC_annotation"
in_regions_B=$proj_dir/output/data/figure2/peaks/B_enhancers.bed
in_regions_T=$proj_dir/output/data/figure2/peaks/T_enhancers.bed

cd $run_dir

nextflow run $icea_path --peaks $peaks --bed2D $bed2D_230238 --genome mm10 --outdir $outdir_B --close_peak_type distance --close_peak_distance 5000 --close_promoter_type distance --close_promoter_distance_start 5000 --close_promoter_distance_end 5000 --filter_close sum --multiple_anno keep --skip_promoter_promoter -ansi-log false --mode multiple --upset_plot --circos_plot --filter_genes --genes ../genelists/Bcell_genes.txt --in_regions $in_regions_B --circos_use_promoters --save_tmp

nextflow run $icea_path --peaks $peaks --bed2D $bed2D_p2c2 --genome mm10 --outdir $outdir_T --close_peak_type distance --close_peak_distance 5000 --close_promoter_type distance --close_promoter_distance_start 5000 --close_promoter_distance_end 5000 --filter_close sum --multiple_anno keep --skip_promoter_promoter -ansi-log false --mode multiple --upset_plot --circos_plot --filter_genes --genes ../genelists/Tcell_genes.txt --in_regions $in_regions_T --circos_use_promoters --save_tmp

