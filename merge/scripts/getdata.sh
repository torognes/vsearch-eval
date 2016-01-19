#!/bin/bash

mkdir -p data

cd data

if [ ! -e frag_1.fastq.gz ]; then
    wget http://gage.cbcb.umd.edu/data/Staphylococcus_aureus/Data.original/frag_1.fastq.gz
fi

if [ ! -e frag_2.fastq.gz ]; then
    wget http://gage.cbcb.umd.edu/data/Staphylococcus_aureus/Data.original/frag_2.fastq.gz
fi
