#!/bin/bash

for M in even uneven; do
    
    OUT=results/$M/clustering.metrics

    if [ ! -e $OUT ]; then

        for alg in cluster_fast cluster_smallmem; do
                
            for prog in usearch usearch8 vsearch; do
            
                for F in results/$M/$M.shuffle_*.fasta.${prog}.$alg.*.uc.conf.txt.res.txt; do
                    base=$(basename $F)
                    shuffle=$(echo $base | cut -d\. -f2 | cut -d_ -f2)
                    id=$(echo $base | cut -d\. -f6)

                    recall=$(cut -d, -f1 $F)
                    precision=$(cut -d, -f2 $F)
                    NMI=$(cut -d, -f3 $F)
                    rand=$(cut -d, -f4 $F)
                    adjustedrand=$(cut -d, -f5 $F)
                    
                    echo ${prog},$alg,$shuffle,$id,recall,$recall >> $OUT
                    echo ${prog},$alg,$shuffle,$id,precision,$precision >> $OUT
                    echo ${prog},$alg,$shuffle,$id,NMI,$NMI >> $OUT
                    echo ${prog},$alg,$shuffle,$id,rand,$rand >> $OUT
                    echo ${prog},$alg,$shuffle,$id,adjustedrand,$adjustedrand >> $OUT
                    
                    clusters=$(grep -c "^C" results/$M/$M.shuffle_$shuffle.fasta.${prog}.$alg.$id.uc)
                    
                    echo ${prog},$alg,$shuffle,$id,clusters,$clusters >> $OUT
                        
                done
                
            done

        done
            
    fi
    
done
