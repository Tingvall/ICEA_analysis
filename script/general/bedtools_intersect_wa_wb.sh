#!/bin/bash
#Usage: bedtools_intersect_wa.sh <bed1> <bed2> <output>

#Activate conda env
source /opt/anaconda3/bin/activate general_bioinfo_tools

#Run bedttols intersect with -wa option
bedtools intersect -wa -wb -a $1 -b $2 > $3
