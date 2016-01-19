#!/bin/bash

P=$1

THREADS=8
DIR=results
ID=0.5
MINSEQLENGTH=1
MAXREJECTS=32

USEARCH=$(which usearch)
VSEARCH=$(which vsearch)

mkdir -p $DIR

if [ "$P" == "u" ]; then
    PROG=$USEARCH
else
    if [ "$P" == "v" ]; then
	PROG=$VSEARCH
    else
        if [ "$P" == "b" ]; then
            PROG=blastall
            MEGA=F
        else
            if [ "$P" == "m" ]; then
                PROG=blastall
                MEGA=T
            else
	        echo You must specify u, v, b or m as first argument
	        exit
            fi
        fi
    fi
fi

case $P in

    b|m)
        
        echo Running Blast $MEGA
        
        /usr/bin/time $PROG \
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
        
        ;;
    
    u|v)
        
        echo Running ${P}search
        
        /usr/bin/time $PROG \
            --usearch_global $DIR/qq.fsa \
            --db $DIR/db.fsa \
            --minseqlength $MINSEQLENGTH \
            --id $ID \
            --maxaccepts 1 \
            --maxrejects $MAXREJECTS \
            --strand plus \
            --threads $THREADS \
            --userout $DIR/userout.$P.txt \
            --userfields query+target+id+qcov
        ;;

esac

echo Sort

sort -nr -k3 $DIR/userout.$P.txt > $DIR/sortout.$P.txt

echo Results

GOLD=$(grep -c "^>" $DIR/qq.fsa)

./scripts/stats.pl $GOLD $DIR/sortout.$P.txt $DIR/curve.$P.txt

rm $DIR/temp.fsa $DIR/q.fsa $DIR/qq.fsa $DIR/db.fsa $DIR/userout.$P.txt
