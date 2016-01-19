#!/bin/bash

mkdir -p data

cd data

for org in Staphylococcus_aureus Rhodobacter_sphaeroides Hg_chr14; do
    
    for strand in 1 2; do
        
        F=$org.frag_$strand.fastq.gz

        if [ ! -e $F ]; then
            wget -O $F http://gage.cbcb.umd.edu/data/$org/Data.original/frag_$strand.fastq.gz
        fi

    done

fi
