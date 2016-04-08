#!/bin/bash

mkdir -p data

cd data

# Get Staphylococcus aureus reference genome, strain USA300_TCH1516

ASM=GCA_000017085.1_ASM1708v1
URL=ftp://ftp.ncbi.nlm.nih.gov/genomes/all/$ASM/${ASM}_genomic.fna.gz

if [ ! -e ${ASM}_genomic.fna.gz ]; then
    wget -nv $URL
fi

# Get Rhodobacter sphaeroides reference genome, strain 1.2.4

ASM=GCA_000273405.1_Rhod_Spha_2_4_1_V1
URL=ftp://ftp.ncbi.nlm.nih.gov/genomes/all/$ASM/${ASM}_genomic.fna.gz

if [ ! -e ${ASM}_genomic.fna.gz ]; then
    wget -nv $URL
fi

# Get reads from GAGE-B

#for name in Staphylococcus_aureus Rhodobacter_sphaeroides Hg_chr14; do
for name in Staphylococcus_aureus Rhodobacter_sphaeroides; do
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
