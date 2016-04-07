#!/bin/bash

THREADS=8

ID_MIN=80
ID_STEP=1
ID_MAX=99

for M in even uneven; do

    for F in results/$M/$M.shuffle_*.fasta; do

        for ID in $(seq -w $ID_MIN $ID_STEP $ID_MAX); do

            for P in usearch usearch8 vsearch; do

                UC=$F.$P.cluster_fast.$ID.uc

                if [ ! -e $UC ]; then

                    echo Clustering with $P at id $ID on $F

                    /usr/bin/time $P --cluster_fast $F --id 0.$ID --uc $UC --threads $THREADS

                fi

                UC=$F.$P.cluster_smallmem.$ID.uc

                if [ ! -e $UC ]; then

                    echo Clustering with $P at id $ID on $F

                    case $P in
                        usearch)
                            /usr/bin/time $P --sortbysize $F --sizein --sizeout --output results/$M/temp.fasta
                            /usr/bin/time $P --cluster_smallmem results/$M/temp.fasta --usersort --id 0.$ID --uc $UC
                            ;;

                        usearch8)
                            /usr/bin/time $P --sortbysize $F --fastaout results/$M/temp.fasta
                            /usr/bin/time $P --cluster_smallmem results/$M/temp.fasta --sortedby size --id 0.$ID --uc $UC
                            ;;

                        vsearch)
                            /usr/bin/time $P --sortbysize $F --sizein --sizeout --output results/$M/temp.fasta --threads $THREADS
                            /usr/bin/time $P --cluster_smallmem results/$M/temp.fasta --usersort --id 0.$ID --uc $UC --threads $THREADS
                            ;;
                    esac

                    rm results/$M/temp.fasta

                fi

            done

        done

    done

done
