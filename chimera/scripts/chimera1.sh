#!/bin/bash

THREADS=2

echo Create folders
mkdir -p ./data ./results/{clust,derep}

## Get reference sequences
REF="gold.fa"
SHA1="744746b83a57b3475fb3fc958cb25a78e93db0bf"
check_status=$(cd ./data/ ; echo "$SHA1  $REF" > shasum.txt ; shasum --status --check shasum.txt ; echo $?)
if [[ ! -e ./data/$REF || ${check_status} != 0 ]] ; then
    echo "Downloading reference database"
    wget -nv -O ./data/${REF} http://drive5.com/uchime/${REF}
fi

#for D in SILVA_Illumina SILVA_noisefree GG_Illumina GG_noisefree ; do
for D in SILVA_Illumina GG_Illumina ; do

    echo Processing dataset $D

    for n in clust derep ; do
        
        if [ $n == "clust" ]; then
            
            if [ ! -e results/$n/${D}_clust.fa ]; then
                
                echo Clustering 

                usearch \
                    --cluster_fast data/$D.fa \
                    --id 0.97 \
                    --sizeout \
                    --threads $THREADS \
                    --centroids results/$n/${D}_clust.fa
                
            fi
            
        else
            
            if [ ! -e results/$n/${D}_derep.fa ]; then
                
                echo Dereplicating

                usearch \
                    --derep_fulllength data/$D.fa \
                    --sizeout \
                    --threads $THREADS \
                    --output results/$n/${D}_derep.fa
                
            fi
            
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
                        
                        /usr/bin/time -p \
                            $p --uchime_denovo results/$n/${D}_${n}.fa \
                            --strand plus \
                            --uchimeout $RES \
                            $THROPT \
                            > $LOG 2>&1
                        
                    else
                        
                        /usr/bin/time -p \
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
                    perl scripts/roc2.pl $BASE.sorteduchime > $BASE.roc
                fi

            done

        done
        
        
    done
    
    echo Plotting
    
    if [ ! -e results/$D.pdf ]; then
        Rscript scripts/plot.R $D
    fi

done

echo "Timing (usearch7, usearch8, vsearch)"

for m in dn ref ; do

    echo $m

#    for D in SILVA_Illumina SILVA_noisefree GG_Illumina GG_noisefree ; do
    for D in SILVA_Illumina GG_Illumina ; do
        for n in clust derep ; do
            U7=$(tail -3 results/$n/${D}_${n}_usearch_$m.log  | grep real | cut -c6-)
            U8=$(tail -3 results/$n/${D}_${n}_usearch8_$m.log | grep real | cut -c6-)
            V=$(tail  -3 results/$n/${D}_${n}_vsearch_$m.log  | grep real | cut -c6-)
        done
        echo $U7 $U8 $V
    done
done

echo Done

exit 0
