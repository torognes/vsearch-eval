#!/bin/bash

mkdir -p data

cd data

for M in even uneven; do

    if [ ! -e $M.fasta.bz2 ]; then

        echo Downloading dataset $M

        wget -nv http://sbr2.sb-roscoff.fr/download/externe/de/fmahe/$M.fasta.bz2

    fi

done
