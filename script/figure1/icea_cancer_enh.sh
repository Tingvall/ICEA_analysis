#!/bin/bash
source /opt/anaconda3/bin/activate ICE_A_env
icea_path="/mnt/data/bioinfo_tools_and_refs/bioinfo_tools/ICE_A/ICE_A.nf"
proj_dir="/mnt/data/common/tobias/tg/ICE_A/ICEA_analysis"
run_dir=$proj_dir/output/data/figure1/cancer_enhancers
peaks=$run_dir/essential_enhancer_info.txt
tss=$run_dir/hg38_tss_2500.txt

bed2D_hct=$run_dir/int_HCT116.bed
bed2D_a549=$run_dir/int_A549.bed

cd $run_dir

nextflow run $icea_path --peaks $peaks --bed2D $bed2D_hct --genome hg38 --outdir enh_anno_HCT116 --close_peak_type distance --close_peak_distance 5000 --close_promoter_type distance --close_promoter_distance_start 5000 --close_promoter_distance_end 5000 --filter_close sum --multiple_anno keep --proximity_unannotated -ansi-log false --tss $tss --interaction_score_column 7 --binsize 10000

nextflow run $icea_path --peaks $peaks --bed2D $bed2D_hct --genome hg38 --outdir enh_anno_HCT116_overlap --close_peak_type overlap --close_promoter_type overlap --filter_close sum --multiple_anno keep -ansi-log false --tss $tss --interaction_score_column 7 --binsize 10000

nextflow run $icea_path --peaks $peaks --bed2D $bed2D_a549 --genome hg19 --outdir enh_anno_A549 --close_peak_type distance --close_peak_distance 5000 --close_promoter_type distance --close_promoter_distance_start 5000 --close_promoter_distance_end 5000 --filter_close sum --multiple_anno keep --proximity_unannotated -ansi-log false --tss $tss --interaction_score_column 7 --binsize 10000
