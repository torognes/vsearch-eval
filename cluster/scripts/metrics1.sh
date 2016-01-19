#!/bin/bash

for M in even uneven; do
    
    for F in results/$M/$M.*.conf.txt; do
        
        R=$F.res.txt
        
        if [ ! -e $R ]; then
            
            perl ./scripts/CValidate.pl --cfile=$F > $R
            
        fi
        
    done
    
done
