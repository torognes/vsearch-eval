#!/bin/bash

for P in usearch usearch8 vsearch; do

    SUM=0
    COUNT=0
    for F in results/log.$P.*.txt; do
        T=$(grep real $F | cut -c 6- | sed -e "s/\.//g")
        SUM=$(( $SUM + $T ))
        COUNT=$(( $COUNT + 1 ))
    done
    AVERAGE=$(( ( $SUM + $COUNT - 1 ) / $COUNT ))

    AVERAGE=$(echo $AVERAGE | sed -e "s/\(..\)$/.\1/g")
    echo -e "$P\t$AVERAGE"

done
