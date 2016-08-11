#!/bin/bash

REPLICATES=10

for D in even uneven; do
    for A in fast smallmem; do
        for P in usearch usearch8 vsearch; do
            for id in 80 90 95 96 97 98 99; do
                
                for S in $(seq 1 $REPLICATES); do

                    N=$(cat results/$D/$D.shuffle_$S.fasta.$P.cluster_$A.$id.log | grep ^real | cut -c6-)

                    echo -e "$D\t$A\t$P\t$id\t$N";
                    
                done
            done
        done
    done
done
