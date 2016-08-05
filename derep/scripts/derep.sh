#!/bin/bash

THREADS=8
REP=3

mkdir -p data results

for M in even uneven; do

    Z=data/$M.fasta.bz2
    F=data/$M.fasta

    if [ ! -e $F ]; then

        if [ ! -e $Z ]; then
            echo Downloading dataset $M
            cd data
            wget http://sbr2.sb-roscoff.fr/download/externe/de/fmahe/$M.fasta.bz2
            cd ..
        fi

        echo Decompressing
        bunzip2 -c $Z > $F

    fi

done

M=BioMarKs

Z=data/$M.fsa.gz
F=data/$M.fasta

if [ ! -e $F ]; then

    if [ ! -e $Z ]; then
        echo Copying dataset $M
        cp -a ../subsample/$Z $Z
    fi

    echo Decompressing
    gunzip -c $Z > $F

fi

for D in derep_fulllength derep_prefix; do

    for M in even uneven BioMarKs; do

        for P in vsearch usearch usearch8; do

            echo Running $D with $P on $M dataset

            for R in $(seq -w 1 $REP); do

                OUT=results/temp.derep.fasta
                LOG=results/$M.$P.$D.$R.log

                if [ ! -e $LOG ]; then

                    case $P in

                        usearch|vsearch)
                        /usr/bin/time -p $P --$D data/$M.fasta --output $OUT --sizeout --threads $THREADS > $LOG 2>&1
                        ;;

                        usearch8)
                        /usr/bin/time -p $P --$D data/$M.fasta --fastaout $OUT --sizeout --threads $THREADS > $LOG 2>&1
                        ;;

                    esac

                fi

                echo $(tail -3 $LOG | grep real | cut -c5-)

            done
        done
    done
done
