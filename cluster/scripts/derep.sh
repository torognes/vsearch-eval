#!/bin/bash

VSEARCH=$(which vsearch)

for M in even uneven; do

    if [ ! -e results/$M/$M.derep.fasta ]; then

        echo Dereplicating $M dataset
        
        $VSEARCH --derep_fulllength data/$M/$M.fasta.bz2 --output results/$M/$M.derep.fasta --sizeout --fasta_width 0 --relabel_sha1

        echo Done

    fi

done
