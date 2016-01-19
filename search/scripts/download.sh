#!/bin/bash

mkdir -p data

if [ ! -e data/Rfam_11_0.fasta ]; then
    
    cd data

    echo Downloading dataset
    
    wget ftp://ftp.ebi.ac.uk/pub/databases/Rfam/11.0/Rfam.fasta.gz

    gunzip Rfam.fasta.gz
    
    mv Rfam.fasta Rfam_11_0.fasta
    
    cd ..
    
fi
