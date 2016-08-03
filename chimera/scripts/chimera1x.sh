#!/bin/bash

# Chimera detection eval with multiple clustering thresholds

THREADS=2

echo Create folders
mkdir -p ./data

## Get reference sequences
REF="gold.fa"
SHA1="744746b83a57b3475fb3fc958cb25a78e93db0bf"
check_status=$(cd ./data/ ; shasum --status -c <<< "${SHA1}  ${REF}" ; echo $?)
if [[ ! -e ./data/$REF || ${check_status} != 0 ]] ; then
    echo "Downloading reference database"
    wget -O ./data/${REF} http://drive5.com/uchime/${REF}
fi

for D in SILVA_Illumina SILVA_noisefree GG_Illumina GG_noisefree ; do

    for j in $(seq 90 1 99) ; do
        
        n=clust_$j

        mkdir -p ./results/$n

        if [ ! -e results/$n/${D}_$n.fa ]; then
            
            echo Clustering at id $j
            
            usearch \
                --cluster_fast data/$D.fa \
                --id 0.$j \
                --sizeout \
                --threads $THREADS \
                --centroids results/$n/${D}_$n.fa
            
        fi
        
        for m in dn ref; do

            for p in usearch usearch8 vsearch; do

                echo Chimera detection with $p using $m and $n

                BASE=results/$n/${D}_${n}_${p}_${m}
                RES=$BASE.uchime
                LOG=$BASE.log

                if [ ! -e $RES ]; then

                    if [ $m == "dn" ]; then
                        
                        if [ $p == "vsearch" ]; then
                            THROPT="--threads $THREADS"
                        else
                            THROPT=""
                        fi
                        
                        /usr/bin/time \
                            $p --uchime_denovo results/$n/${D}_$n.fa \
                            --strand plus \
                            --uchimeout $RES \
                            $THROPT \
                            > $LOG 2>&1
                        
                    else
                        
                        /usr/bin/time \
                            $p --uchime_ref results/$n/${D}_${n}.fa \
                            --strand plus \
                            --db data/$REF \
                            --threads $THREADS \
                            --uchimeout $RES \
                            > $LOG 2>&1
                        
                    fi
                    
                fi
                
                if [ ! -e $BASE.sorteduchime ]; then
                    if [ $p == "usearch8" ]; then
                        sort -nr -k1 -k16 $RES | cut -f2,17 > $BASE.sorteduchime
                    else
                        sort -nr -k1 -k17 $RES | cut -f2,18 > $BASE.sorteduchime
                    fi
                fi

                if [ ! -e $BASE.roc ]; then
#                    perl scripts/roc.pl $BASE.sorteduchime > $BASE.roc
                    perl scripts/roc2.pl $BASE.sorteduchime > $BASE.roc
                fi

            done

        done
        
        echo Plotting
    
        if [ ! -e results/$n/$D.pdf ]; then
            Rscript scripts/plot1x.R $D $n
        fi

    done
        
done

echo Done

exit 0
