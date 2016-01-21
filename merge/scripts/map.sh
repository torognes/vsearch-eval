#!/bin/bash

THREADS=8
REF=GCA_000013425.1_ASM1342v1_genomic.fna.gz

cd data

if [ ! -e $REF.sa ]; then
    bwa index $REF
fi

cd ..

cd results

#OPT="-t $THREADS -w 1"
OPT="-t $THREADS "

name=Staphylococcus_aureus
for P in usearch vsearch; do
    OUT=$name.merged.$P.sam
    if [ ! -e $OUT ]; then
        echo Mapping $name.merged.$P.fastq
        bwa mem $OPT ../data/$REF $name.merged.$P.fastq > $OUT
        cut -f2 $OUT | sort | uniq -c
    fi
done
