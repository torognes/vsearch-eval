#!/bin/bash

THREADS=8
MINOVLEN=10
MAXDIFFS=5
MINHSP=$MINOVLEN

mkdir -p results

#for name in Staphylococcus_aureus Rhodobacter_sphaeroides Hg_chr14 mcbath; do
for name in Staphylococcus_aureus mcbath; do

    for P in usearch usearch8 vsearch; do
        
        R1=data/${name}_1.fastq
        R2=data/${name}_2.fastq
        F=results/$name.merged.$P.fastq
        G=results/$name.PEAR

        if [ ! -e $F ]; then

            echo Merging $name with $P

            if [ $P == "PEAR" ]; then

                cmd="/usr/bin/time -p $P \
                  --forward-fastq $R1 --reverse-fastq $R2 --output $G \
                  --min-overlap $MINOVLEN \
                  --threads $THREADS"

                echo Running $cmd
                
                $cmd
                
                mv $G.assembled.fastq $F
                rm $G.*
                
            else
                
                cmd="/usr/bin/time -p $P \
                      --fastq_mergepairs $R1 --reverse $R2 --fastqout $F \
                      --fastq_minovlen $MINOVLEN --fastq_maxdiffs $MAXDIFFS \
                      --threads $THREADS --minhsp $MINHSP"
                
                echo Running $cmd
                
                $cmd

            fi

        fi

    done

done
