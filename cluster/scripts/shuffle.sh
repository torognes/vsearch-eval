#!/bin/bash

THREADS=8
REPLICATES=10

for i in $(seq -w $REPLICATES); do

    for M in even uneven; do

        OUT=results/$M/$M.shuffle_$i.fasta

        if [ ! -e $OUT ]; then

            vsearch --shuffle results/$M/$M.derep.fasta --output $OUT --randseed $i --threads $THREADS

        fi

    done

done
