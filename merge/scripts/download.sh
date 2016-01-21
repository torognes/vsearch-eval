#!/bin/bash

mkdir -p data

cd data

# Get Staph. aureus reference genome

# Assembly of M0927 strain
# ftp://ftp.ensemblgenomes.org/pub/bacteria/release-30/fasta/bacteria_29_collection/staphylococcus_aureus_m0927/dna/Staphylococcus_aureus_m0927.GCA_000362205.1.30.dna.genome.fa.gz

# Complete reference strain NCTC 8325
STAAU_REF=GCA_000013425.1_ASM1342v1_genomic.fna.gz
STAAU_URL=ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA_000013425.1_ASM1342v1/$STAAU_REF

if [ ! -e $STAAU_REF ]; then
    wget -nv $STAAU_URL
fi

# Get data from GAGE-B

for name in Staphylococcus_aureus Rhodobacter_sphaeroides Hg_chr14; do
    for strand in 1 2; do

        F=${name}_$strand.fastq
        URL="http://gage.cbcb.umd.edu/data/$name/Data.original/frag_$strand.fastq.gz"

        if [ ! -e $F ]; then
            if [ ! -e $F.gz ]; then
                wget -nv -O $F.gz $URL
            fi
            gunzip $F.gz
        fi
    done
done

# Get Methylococcus capsulatus Bath reads

F1=mcbath_1.fastq
F2=mcbath_2.fastq

if [ ! -e $F2 ]; then

    N=pandaseq_sampledata.tar
    URL=http://neufeldserver.uwaterloo.ca/~apmasell/$N

    if [ ! -e $N ]; then
        wget -nv $URL
    fi

    tar xf $N

    rm $N

    bunzip2 mcbath_1.fastq.bz2
    bunzip2 mcbath_2.fastq.bz2

fi

cd ..
