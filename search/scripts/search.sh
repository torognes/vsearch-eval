#!/bin/bash

./scripts/download.sh

mkdir -p results

for s in 1 2 3 4 5 6 7 8 9 10; do

    scripts/makedb.sh $s
    
    OUT=results/curve.s$s..pdf
    
    if [ ! -e $OUT ]; then
        
        for n in u v; do
            scripts/eval.sh $n
        done
        
        Rscript scripts/plot.R
        mv results/curve.pdf $OUT
        
    fi
    
done
