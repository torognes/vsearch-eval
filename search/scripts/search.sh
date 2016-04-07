#!/bin/bash

./scripts/download.sh

mkdir -p results

for s in 1 2 3 4 5 6 7 8 9 10; do

    OUT=results/curve.s$s.pdf
    
    if [ ! -e $OUT ]; then
        
        scripts/makedb.sh $s
    
        for n in usearch usearch8 vsearch; do
            scripts/eval.sh $n
        done
        
        Rscript scripts/plot.R
        mv results/curve.pdf $OUT

        rm results/curve.usearch.txt
        rm results/curve.usearch8.txt
        rm results/curve.vsearch.txt

        rm results/qq.fsa
        rm results/db.fsa

    fi
    
done
