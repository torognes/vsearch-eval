#!/bin/bash

for M in even uneven; do

    TAXFILE=results/$M/$M.spec.ualn
#    TAXFILE=results/$M/$M.spec.valn

    for F in results/$M/$M.*.uc; do

        CONF=$F.conf.txt

        if [ ! -e $CONF ]; then

            echo Creating confusion table for $F
            
            ./scripts/uc2confusiontable.pl $TAXFILE $F > $CONF

        fi
        
    done

done
