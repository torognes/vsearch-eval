#!/bin/bash

./scripts/getdata.sh

mkdir -p results

for p in usearch vsearch; do

    /usr/bin/time $P --fastq_mergepairs data/frag_1.fastq.gz --reverse data/frag_2.fastq.gz --fastqout results/merged.fastq --fastq_ascii ? --fastq_qmin ? --fastq_qmax ? --fastq_minovlen 10 --fastq_maxdiffs 5

done
