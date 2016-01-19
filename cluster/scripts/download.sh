#!/bin/bash

mkdir -p data

for M in even uneven; do

    mkdir -p data/$M

    if [ ! -e data/$M/$M.fasta.bz2 ]; then

        cd data/$M

        echo Downloading dataset $M

        wget http://sbr2.sb-roscoff.fr/download/externe/de/fmahe/$M.fasta.bz2

        cd ../..

    fi

done
