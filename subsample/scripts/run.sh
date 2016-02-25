#!/bin/bash

THREADS=8

mkdir -p results

#BASE=TARA_V9_264_samples
BASE=BioMarKs
DATAGZ=data/$BASE.fsa.gz
DATA=data/$BASE.fsa
RES=results/$BASE.subsample.tsv
REPLICATES=100

gunzip -c -d $DATAGZ > $DATA

echo -e "fraction\tprogram\tabundance" > $RES
for f in 1.0 1.5 2.5 5.0; do
    for n in $(seq 1 $REPLICATES); do
        for p in usearch8 vsearch; do
            
            $p --fastx_subsample $DATA \
                --sample_pct $f \
                --sizein \
                --sizeout \
                --threads $THREADS \
                --fastaout results/temp.fasta
            t=$(head -1 results/temp.fasta | cut -d= -f2 | cut -d\; -f1)
            echo -e "$f\t$p\t$t" >> $RES
            rm results/temp.fasta
            
        done
    done
done

cat data/perfect.tsv >> $RES
