#!/bin/bash

for D in even uneven; do
    for A in fast smallmem; do
        for P in usearch usearch8 vsearch; do
            for id in 80 90 95 96 97 98 99; do
                for F in results/$D/$D.shuffle_*.fasta.$P.cluster_$A.$id.log; do
                    if [ -e $F ] ; then
                        N=$(grep "^real" $F | cut -c6-)
                        echo -e "$D\t$A\t$P\t$id\t$N";
                    fi
                done
            done
        done
    done
done
