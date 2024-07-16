#!/bin/bash
#Usage: bedtools_intersect_wa.sh <bed1> <bed2> <sample1_id> <sample2_id> <output>

#Activate conda env
source /opt/anaconda3/bin/activate general_bioinfo_tools

#Extract first 3 columns and add sample id in 4th column
awk -v FS='\t' -v OFS='\t' -v sampleid=$3 '{print $1,$2,$3,sampleid}' $1 > tmp_sample1.bed
awk -v FS='\t' -v OFS='\t' -v sampleid=$4 '{print $1,$2,$3,sampleid}' $2 > tmp_sample2.bed

#Join and run bedtools merge
cat tmp_sample1.bed tmp_sample2.bed > tmp_sample_merge.bed
sort -k1,1 -k2,2n tmp_sample_merge.bed > tmp_sample_merge_sort.bed
bedtools merge -i tmp_sample_merge_sort.bed -c 4 -o distinct > $5
rm tmp_*.bed
