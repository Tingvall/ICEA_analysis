#!/bin/bash
# STAR and RSEM mapping of Immgen RNA-seq data. Paired-end
# Load environemnt: conda activate rnaseq_env

sample_path="/mnt/data/common/public_data/rnaseq"
sub_path="$sample_path/GSE109125_Immgen/"

threads=24
refdir_size_mm10="/mnt/data/bioinfo_tools_and_refs/refs/index/STAR/mm10.gencode.GRCm38.p5.vM15_gtf/chrNameLength.txt"
star_refdir_mm10="/mnt/data/bioinfo_tools_and_refs/refs/index/STAR/mm10.gencode.GRCm38.p5.vM15_gtf"
rsem_refdir_mm10="/mnt/data/bioinfo_tools_and_refs/refs/index/rsem/mm10.GRCm38.p5.v15_gtf/mm10.GRCm38.p5.v15_gtf"
ref_gen="mm10"
genome_size=2652783500 #mm10 genome size non-N bases

samples="LTHSC.34+_1 LTHSC.34+_2 LTHSC.34-_1 LTHSC.34-_2 STHSC_1 STHSC_2 MPP4_1 MPP4_2 CLP_1 CLP_2 FrA_1 FrA_2 FrBC_1 FrBC_2 FrE_1 FrE_2 DN1_1 DN1_2 DN2a_1 DN2b_1 DN2b_2 DN3_1 DN3_2"


for i in ${samples}; do

	directory=${sub_path}${i}

	echo "${directory}"

	#Check if directory exists
	[ -d ${directory} ] && echo "${directory} exists."
	[ -d ${directory} ] || echo "${directory} DOES NOT exist."
	[ -d ${directory} ] || exit

	cd ${directory}
	mkdir -p ${i}.${ref_gen}.rsem
	#Unzip and cat the files.
	gunzip -c *R1*.gz > ${i}.${ref_gen}.rsem/${i}.R1.fastq
	gunzip -c *R2*.gz > ${i}.${ref_gen}.rsem/${i}.R2.fastq

	cd ${i}.${ref_gen}.rsem

	#Run fastqc on untrimmed files.
	fastqc ${i}.R1.fastq
	fastqc ${i}.R2.fastq

	#Trim fastq files.
	trim_galore --paired --fastqc --length 20 ${i}.R1.fastq ${i}.R2.fastq

	#STAR map trimmed fastq-file against custom mm10.
	STAR --genomeDir ${star_refdir_mm10} --readFilesIn  ${i}.R1_val_1.fq ${i}.R2_val_2.fq --runThreadN ${threads}  --quantMode TranscriptomeSAM --outFilterType BySJout --outFilterMultimapNmax 20 --alignSJoverhangMin 8 --alignSJDBoverhangMin 1 --sjdbScore 1 --outFilterMismatchNmax 999 --outFilterMismatchNoverLmax 0.04 --alignIntronMin 20 --alignIntronMax 1000000 --alignMatesGapMax 1000000 --outSAMstrandField intronMotif --outWigStrand Unstranded --outFileNamePrefix ${i}.${ref_gen}. --outReadsUnmapped Fastx

	mkdir -p ${i}.for_genome_browser
	mkdir -p ${i}.rsem_processed_files
        ########################################################################################

        #### Bigwig generation from the sorted STAR output sam-file

        #Convert sam to bam
        samtools view -bS -o ${i}.STAR.bam ${i}.${ref_gen}.Aligned.out.sam

        # convert bam to bed
        bamToBed -i ${i}.STAR.bam  -split > ${i}.STAR.bed

        # sort bed-file
        bedSort ${i}.STAR.bed ${i}.STAR.${ref_gen}.bed

        # get normaliztion factor for bigwig file
        scalevar_STAR=$( cat ${i}.STAR.${ref_gen}.bed | wc -l )
        scalevar_STAR=$( echo "scale=4; 1000000/$scalevar_STAR" | bc )

        # compile reads
        genomeCoverageBed -bg -i ${i}.STAR.${ref_gen}.bed -g ${refdir_size_mm10} -scale $scalevar_STAR -split > ${i}.STAR.${ref_gen}.bg

        #convert bedgraph to bigwig file
        bedGraphToBigWig ${i}.STAR.${ref_gen}.bg ${refdir_size_mm10} ${i}.STAR.${ref_gen}.bw
        mv ${i}.STAR.${ref_gen}.bw ${i}.for_genome_browser


        #Cleaning up intermediate files
        rm *.bg *.bed
	rm *Unmapped*

        ###########################################################################################

   	#### prepare for RSEM: sort transcriptome BAM to ensure the order of the reads, to make RSEM output (not pme) deterministic. This is for single-end read data and the pipe is taken from the ENCODE script.
        mv ${i}.${ref_gen}.Aligned.toTranscriptome.out.bam Tr.bam
	cat <( samtools view -H Tr.bam ) <( samtools view -@ 10 Tr.bam  | awk '{printf "%s", $0 " "; getline; print}' | sort -T ./ | tr ' ' '\n' ) | samtools view -@ 10 -bS - > ${i}.${ref_gen}.Aligned.toTranscriptome.out.bam

    	#RSEM, rsem-calculate-expression on the Aligned.toTranscriptome.out.bam generated by STAR and ouputs output-genome-bam for Homer tagdir generations.
	rsem-calculate-expression -p ${threads} --paired-end --alignments --forward-prob 0 --seed-length 20 --output-genome-bam --sampling-for-bam --estimate-rspd --seed 12345 --calc-ci --append-names ${i}.${ref_gen}.Aligned.toTranscriptome.out.bam ${rsem_refdir_mm10} ${i}.Aligned.toTranscriptome.rsem.out
   	rsem-plot-model ${i}.Aligned.toTranscriptome.rsem.out ${i}.Aligned.toTranscriptome.out.pdf

	## Cleaning up and moving files
	rm *.bed *.bg
	mv *.results* ${i}.rsem_processed_files/
	mv ${i}.Aligned.toTranscriptome.rsem.out.genome.bam *Aligned.toTranscriptome.out.stat* ${i}.rsem_processed_files/
	mv ${i}.Aligned.toTranscriptome.out.pdf ${i}.rsem_processed_files/
        mv *.bai *.out *.tab ${i}.rsem_processed_files/
	rm *.fastq *.bam *.sam *.fq
done

