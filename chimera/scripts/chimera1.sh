#!/bin/bash

USEARCH=$(which usearch)
VSEARCH=$(which vsearch)

THREADS=8

echo Create folders

mkdir -p data results/clust results/derep


REF=gold.fa

if [ ! -e data/$REF ]; then
    echo Downloading reference database
    wget -O data/gold.fa http://drive5.com/uchime/gold.fa
fi


for D in SILVA_Illumina SILVA_noisefree GG_Illumina GG_noisefree; do

    for n in clust derep; do
        
        if [ $n == "clust" ]; then
            
            if [ ! -e results/$n/${D}_clust.fa ]; then
                
                echo Clustering 

                ${USEARCH} --cluster_fast data/$D.fa --id 0.95 \
                    --sizeout \
                    --threads $THREADS \
                    --centroids results/$n/${D}_clust.fa
                
            fi
            
        else
            
            if [ ! -e results/$n/${D}_derep.fa ]; then
                
                echo Dereplicating

                ${USEARCH} --derep_fulllength data/$D.fa \
                    --sizeout \
                    --threads $THREADS \
                    --output results/$n/${D}_derep.fa
                
            fi
            
        fi

        for m in dn ref; do

            for p in usearch vsearch; do
                
                if [ $p == "usearch" ]; then
                    PROG=$USEARCH
                else
                    PROG=$VSEARCH
                fi

                echo Chimera detection with $p using $m and $n

                BASE=results/$n/${D}_${n}_${p}_${m}
                RES=$BASE.uchime

                if [ ! -e $RES ]; then

                    if [ $m == "dn" ]; then
                        
                        if [ $p == "vsearch" ]; then
                            THROPT="--threads $THREADS"
                        else
                            THROPT=""
                        fi
                        
                        /usr/bin/time \
                            $PROG --uchime_denovo results/$n/${D}_${n}.fa \
                            --strand plus \
                            --uchimeout $RES \
                            $THROPT
                        
                    else
                        
                        /usr/bin/time \
                            $PROG --uchime_ref results/$n/${D}_${n}.fa \
                            --strand plus \
                            --db data/$REF \
                            --threads $THREADS \
                            --uchimeout $RES
                        
                    fi
                    
                fi
                
                if [ ! -e $BASE.sorteduchime ]; then
                    sort -nr -k1 -k17 $RES | cut -f2,18 > $BASE.sorteduchime
                fi

                if [ ! -e $BASE.roc ]; then
                    perl scripts/roc.pl $BASE.sorteduchime > $BASE.roc
                fi

            done

        done
        
        
    done
    
    echo Plotting
    
    if [ ! -e results/$D.pdf ]; then
        Rscript scripts/plot.R $D
    fi

done

echo Done
