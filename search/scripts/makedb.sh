#!/bin/bash

SEED=$1

if [ "x$SEED" == "x" ]; then
    SEED=0
fi

echo Using seed $SEED

#Change REPLICATES to 1000 for timing
REPLICATES=1
DIR=results
DB=data/Rfam_11_0.fasta

mkdir -p $DIR

echo Shuffling data set

vsearch --shuffle $DB --output $DIR/temp.fsa --randseed $SEED

echo Extracting queries and database sequences

./scripts/select.pl $DIR/temp.fsa $DIR/q.fsa $DIR/db.fsa

rm $DIR/temp.fsa

echo Creating replicate queries

rm -f $DIR/qq.fsa
for i in $(seq 1 $REPLICATES); do
    echo -n "$i "
    cat $DIR/q.fsa >> $DIR/qq.fsa
done

rm $DIR/q.fsa

#echo Running formatdb
#formatdb -i $DIR/db.fsa -p F -n $DIR/db -l $DIR/formatdb.log

echo Done
