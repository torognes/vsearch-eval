#!/bin/bash

THREADS=8

cd data



for REF in GCA_000017085.1_ASM1708v1_genomic.fna.gz GCA_000273405.1_Rhod_Spha_2_4_1_V1_genomic.fna.gz mcbath.ref.fasta; do
    if [ ! -e $REF.sa ]; then
        bwa index $REF
    fi
done

cd ..

cd results

R=results.txt

rm -f results.txt

OPT="-t $THREADS -w 1 -O 50,50 -E 50,50 -L 50,50"

for name in Staphylococcus_aureus mcbath Rhodobacter_sphaeroides; do

    if [ $name == mcbath ]; then
        REF=mcbath.ref.fasta
    else
        if [ $name == Rhodobacter_sphaeroides ]; then
            REF=GCA_000273405.1_Rhod_Spha_2_4_1_V1_genomic.fna.gz
        else
            REF=GCA_000017085.1_ASM1708v1_genomic.fna.gz
        fi
    fi

    for P in usearch usearch8 vsearch PEAR; do
        OUT=$name.merged.$P.$REF.sam
        if [ ! -e $OUT ]; then
            echo Mapping $name.merged.$P.fastq against $REF
            bwa mem $OPT ../data/$REF $name.merged.$P.fastq > $OUT
        fi

        PERFECT=$(cut -f6 $OUT | egrep -c "^[0-9]+M$")
        MERGED=$(( $(cat $name.merged.$P.fastq | wc -l) / 4 ))
        PAIRS=$(( $(cat ../data/${name}_1.fastq | wc -l) / 4 ))
        
        PERFECT_MERGED_PCT=$(echo $PERFECT $MERGED | awk '{printf "%.2f \n", 100.0 * $1 /$2}')
        PERFECT_ALL_PCT=$(echo $PERFECT $PAIRS | awk '{printf "%.2f \n", 100.0 * $1 /$2}')
        MERGED_PCT=$(echo $MERGED $PAIRS | awk '{printf "%.2f \n", 100.0 * $1 /$2}')
        
        echo Perfect merges: $PERFECT \($PERFECT_MERGED_PCT % of merged, $PERFECT_ALL_PCT % of all\)
        echo Merges:         $MERGED \($MERGED_PCT %\)
        echo Pairs:          $PAIRS
                
        echo -e "$name\t$P\t$PAIRS\t$MERGED\t$PERFECT\t$MERGED_PCT\t$PERFECT_MERGED_PCT\t$PERFECT_ALL_PCT" >> $R
        
    done
done
