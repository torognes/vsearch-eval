#!/bin/bash

P=$1
S=$2

THREADS=8
DIR=results
ID=0.5
MINSEQLENGTH=1
MAXREJECTS=32

mkdir -p $DIR

date

echo Running $P

case $P in

    usearch|usearch8|vsearch)

        PROG=$P

        /usr/bin/time -p $PROG \
            --usearch_global $DIR/qq.fsa \
            --db $DIR/db.fsa \
            --minseqlength $MINSEQLENGTH \
            --id $ID \
            --maxaccepts 1 \
            --maxrejects $MAXREJECTS \
            --strand plus \
            --threads $THREADS \
            --userout $DIR/userout.$P.txt \
            --userfields query+target+id+qcov \
            > $DIR/log.$P.$S.txt 2>&1
        ;;

    blast|megablast)

        PROG=blastall

        case $P in
            blast)
                echo Running Blast
                MEGA=F
                ;;
            megablast)
                echo Running MegaBlast
                MEGA=T
                ;;
        esac

        /usr/bin/time -p $PROG \
            -p blastn \
            -n $MEGA \
            -d $DIR/db \
            -i $DIR/qq.fsa \
            -S 1 \
            -a $THREADS \
            -v 1 \
            -b 1 \
            -m 9 \
            -o $DIR/blastout.txt
        
        # remove duplicate hits, calc query coverage and remove if too low
        scripts/blastfilter.pl $DIR/blastout.txt > $DIR/userout.$P.txt

        rm $DIR/blastout.txt
        ;;

    *)
	echo Please specify usearch, usearch8, vsearch, blast or megablast as first argument
	exit
        ;;

esac

date

echo Sort

sort -nr -k3,3 $DIR/userout.$P.txt > $DIR/sortout.$P.txt
cp $DIR/sortout.$P.txt $DIR/sortout.$P.$S.txt 

echo Results

GOLD=$(grep -c "^>" $DIR/qq.fsa)

./scripts/stats.pl $GOLD $DIR/sortout.$P.txt $DIR/curve.$P.txt

rm $DIR/userout.$P.txt
#rm $DIR/sortout.$P.txt

date
