#!/bin/bash

#----cluster parameters-------
PROCESSOR=4
MEM="4G"
DURATION="08:00:00"
#------------------------------

#----PATH--------------------
#INDEX=/scratch/share/public_datasets/ngs/genomes_handbuilt/dkcrossm/ucsc.mm10/bowtie2/ucsc.mm10
FASTA=/scratch/share/public_datasets/ngs/genomes_handbuilt/dkcrossm/ucsc.mm10/bowtie2/ucsc.mm10.fa
GTF=/scratch/share/public_datasets/ngs/gtfs/mm10_patched.gtf
INPUT=tophat_results
OUTPUT=cufflinks_results
#---------------------------

mkdir ${OUTPUT}

#for i in GC4-1 GC4-2 GC4-3 T4-1 T4-2 T4-3 C8-1 C8-2 C8-3 T8-1-1 T8-1-2 T8-1-3 T8-2-1 T8-2-2 T8-2-3 C16-1 C16-2 C16-3 T16-1-1 T16-1-2 T16-1-3 T16-2-1 T16-2-2 T16-2-3 MI-07 MI-08 MI-09 MI-13 MI-14 MI-15
for i in GC4-1 GC4-2 GC4-3 T4-1 T4-2 T4-3 C8-1 C8-2 C8-3 T8-1-1 T8-1-2 T8-1-3 T8-2-1 T8-2-2 T8-2-3 C16-1 C16-2 C16-3 T16-1-1 T16-1-2 T16-1-3 T16-2-1 T16-2-2 T16-2-3
#for i in GC4-1

do 
  #echo "${i}"
  COMMAND="cufflinks -p ${PROCESSOR} --upper-quartile-norm -L ${i} -b ${FASTA} -G ${GTF} -o ${OUTPUT}/${i}_clout ${INPUT}/${i}_thout/accepted_hits.bam"
  echo "$COMMAND">temp.script
  cat temp.script >>cufflinks.log
  QSUB_COMMAND="qsub -cwd -S /bin/bash -N ${i}-cuff -pe smp ${PROCESSOR} -l h_rt=${DURATION},s_rt=${DURATION},vf=${MEM} -m eas -M ${USER}@uab.edu temp.script"
  echo -e "\nSubmitting job --> \"${QSUB_COMMAND}\"\n\n\n">>cufflinks.log
  echo `${QSUB_COMMAND}`
  rm temp.script
done
