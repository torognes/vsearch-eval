#!/bin/bash

./scripts/download.sh

mkdir -p results

PROGRAMS="usearch usearch8 vsearch"
REPEATS=20

for s in $(seq 1 $REPEATS); do

    OUT=results/curve.s$s.pdf
    
    if [ ! -e $OUT ]; then
        
        scripts/makedb.sh $s
    
        for n in $PROGRAMS; do
            scripts/eval.sh $n $s
        done
        
        Rscript scripts/plot.R
        mv results/curve.pdf $OUT

        rm results/curve.usearch.txt
        rm results/curve.usearch8.txt
        rm results/curve.vsearch.txt
        rm results/db.fsa

    fi
    
done

for n in $PROGRAMS; do
    scripts/evalall.sh $n $REPEATS
done

Rscript scripts/plot.R
mv results/curve.pdf results/curve.all.pdf
rm results/qq.fsa

scripts/time.sh
