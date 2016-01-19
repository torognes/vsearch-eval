#!/bin/bash

./scripts/getdata.sh

mkdir -p results

for org in Staphylococcus_aureus Rhodobacter_sphaeroides Hg_chr14; do

    for p in usearch vsearch; do
        
        /usr/bin/time $P --fastq_mergepairs data/$org.frag_1.fastq.gz --reverse data/$org.frag_2.fastq.gz --fastqout results/$org.merged.fastq -fastq_qmin 0 -fastq_qmax 40 -fastq_ascii 33 --fastq_minovlen 10 --fastq_maxdiffs 5

    done

done
