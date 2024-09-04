#!/bin/bash
source /opt/anaconda3/bin/activate ICE_A_env
icea_path="/mnt/data/bioinfo_tools_and_refs/bioinfo_tools/ICE_A/ICE_A.nf"
proj_dir="/mnt/data/common/tobias/tg/ICE_A/ICEA_analysis"
run_dir=$proj_dir/output/data/figure3/annotation
peaks_pax5=$run_dir/Pax5_230238_peaks.txt
peaks_tcf7=$run_dir/Tcf7_p2c2_peaks.txt
peaks_gata3=$run_dir/Gata3_p2c2_peaks.txt
bed2D_230238=$proj_dir/data/interactions/230238_H3K4me3_FitHiChIP.interactions_FitHiC_Q0.05_MergeNearContacts.bed
bed2D_p2c2=$proj_dir/data/interactions/P2C2_H3K4me3_FitHiChIP.interactions_FitHiC_Q0.05_MergeNearContacts.bed
cd $run_dir

#Pax5
nextflow run $icea_path --peaks $peaks_pax5 --bed2D $bed2D_230238 --genome mm10 --outdir PAX5_230238_H3K4me3_PLACseq_annotation  --close_peak_type distance --close_peak_distance 5000 --close_promoter_type distance --close_promoter_distance_start 5000 --close_promoter_distance_end 5000 --filter_close sum --multiple_anno keep --skip_promoter_promoter -ansi-log false

#Tcf7
nextflow run $icea_path --peaks $peaks_tcf7 --bed2D $bed2D_p2c2 --genome mm10 --outdir Tcf7_P2C2_H3K4me3_PLACseq_annotation  --close_peak_type distance --close_peak_distance 5000 --close_promoter_type distance --close_promoter_distance_start 5000 --close_promoter_distance_end 5000 --filter_close sum --multiple_anno keep --skip_promoter_promoter -ansi-log false

#Gata3
nextflow run $icea_path --peaks $peaks_gata3 --bed2D $bed2D_p2c2 --genome mm10 --outdir GATA3_P2C2_H3K4me3_PLACseq_annotation  --close_peak_type distance --close_peak_distance 5000 --close_promoter_type distance --close_promoter_distance_start 5000 --close_promoter_distance_end 5000 --filter_close sum --multiple_anno keep --skip_promoter_promoter -ansi-log false
