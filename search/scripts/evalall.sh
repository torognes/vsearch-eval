#!/bin/bash

P=$1
SEEDS=$2

DIR=results

date

echo Overall results for $P

GOLD=$(grep -c "^>" $DIR/qq.fsa)
TOTAL=$(( $GOLD * $SEEDS ))

sort -nr -k3,3 $DIR/sortout.$P.*.txt > $DIR/sortout.$P.txt

./scripts/stats.pl $TOTAL $DIR/sortout.$P.txt $DIR/stats.$P.txt
uniq $DIR/stats.$P.txt > $DIR/curve.$P.txt

rm $DIR/sortout.$P.*.txt
#rm $DIR/stats.$P.txt

date
