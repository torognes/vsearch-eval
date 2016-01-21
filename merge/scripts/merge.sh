#!/bin/bash

./scripts/download.sh

THREADS=8
MINOVLEN=10
MAXDIFFS=5
MINHSP=16

mkdir -p results

for name in Staphylococcus_aureus Rhodobacter_sphaeroides Hg_chr14 mcbath; do

    for P in usearch vsearch; do
        
        R1=data/${name}_1.fastq
        R2=data/${name}_2.fastq
        F=results/$name.merged.$P.fastq

        if [ $P == usearch ]; then
            EXTRA="--minhsp $MINHSP"
        else
            EXTRA=""
        fi

        if [ ! -e $F ]; then

            echo Merging $name with $P

            /usr/bin/time $P \
                --fastq_mergepairs $R1 --reverse $R2 --fastqout $F \
                --fastq_minovlen $MINOVLEN --fastq_maxdiffs $MAXDIFFS \
                --threads $THREADS $EXTRA
        fi

    done

done
