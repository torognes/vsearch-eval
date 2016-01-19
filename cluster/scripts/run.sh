#!/bin/bash

ID_MIN=80
ID_STEP=1
ID_MAX=99

for M in even uneven; do

    for F in results/$M/$M.shuffle_*.fasta; do

        for ID in $(seq -w $ID_MIN $ID_STEP $ID_MAX); do
            
            for P in usearch vsearch; do
                
                UC=$F.$P.cluster_fast.$ID.uc

                if [ ! -e $UC ]; then

                    echo Clustering with $P at id $ID on $F

                    $P --cluster_fast $F --id 0.$ID --uc $UC

                fi

                UC=$F.$P.cluster_smallmem.$ID.uc

                if [ ! -e $UC ]; then

                    echo Clustering with $P at id $ID on $F

                    $P --sortbysize $F --sizein --sizeout --output results/$M/temp.fasta

                    $P --cluster_smallmem results/$M/temp.fasta --usersort --id 0.$ID --uc $UC

                    rm results/$M/temp.fasta
                
                fi

            done

        done
        
    done

done
