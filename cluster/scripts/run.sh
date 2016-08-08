#!/bin/bash

THREADS=8

ID_MIN=80
ID_STEP=1
ID_MAX=99

for M in even uneven; do

    TAXFILE=results/$M/$M.spec.ualn

    for F in results/$M/$M.shuffle_*.fasta; do

        for ID in $(seq -w $ID_MIN $ID_STEP $ID_MAX); do

            for P in usearch usearch8 vsearch; do

                UC=$F.$P.cluster_fast.$ID.uc
                CONF=$UC.conf.txt
                RES=$CONF.res.txt
                LOG=$F.$P.cluster_fast.$ID.log

                if [ ! -e $RES ]; then

                    if [ ! -e $CONF ]; then
                        
                        if [ ! -e $UC ]; then
                            
                            echo Clustering (fast) with $P at id $ID on $F
                            
                            /usr/bin/time -p $P \
                                --cluster_fast $F --id 0.$ID \
                                --uc $UC --threads $THREADS \
                                > $LOG 2>&1
                            
                        fi
                        
                        ./scripts/uc2confusiontable.pl $TAXFILE $UC > $CONF
                        rm $UC

                    fi

                    ./scripts/CValidate.pl --cfile=$CONF > $RES
                    rm $CONF
                    
                fi


                UC=$F.$P.cluster_smallmem.$ID.uc
                CONF=$UC.conf.txt
                RES=$CONF.res.txt
                LOG=$F.$P.cluster_smallmem.$ID.log

                if [ ! -e $RES ]; then

                    if [ ! -e $CONF ]; then
                        
                        if [ ! -e $UC ]; then

                            echo Clustering (smallmem) with $P at id $ID on $F
                            
                            TEMPFASTA=results/$M/temp.fasta

                            case $P in
                                usearch)
                                    /usr/bin/time -p $P --sortbysize $F \
                                        --sizein --sizeout \
                                        --output $TEMPFASTA
                                    /usr/bin/time $P \
                                        --cluster_smallmem $TEMPFASTA \
                                        --usersort --id 0.$ID --uc $UC \
                                    > $LOG 2>&1
                                    ;;
                                
                                usearch8)
                                    /usr/bin/time -p $P --sortbysize $F \
                                        --fastaout $TEMPFASTA
                                    /usr/bin/time $P \
                                        --cluster_smallmem $TEMPFASTA \
                                        --sortedby size --id 0.$ID --uc $UC \
                                        > $LOG 2>&1
                                    ;;
                                
                                vsearch)
                                    /usr/bin/time -p $P --sortbysize $F \
                                        --sizein --sizeout \
                                        --output $TEMPFASTA \
                                        --threads $THREADS
                                    /usr/bin/time -p $P \
                                        --cluster_smallmem $TEMPFASTA \
                                        --usersort --id 0.$ID --uc $UC \
                                        --threads $THREADS \
                                        > $LOG 2>&1
                                    ;;
                            esac
                            
                            rm $TEMPFASTA

                        fi
                        
                        ./scripts/uc2confusiontable.pl $TAXFILE $UC > $CONF
                        rm $UC
                        
                    fi
                    
                    perl ./scripts/CValidate.pl --cfile=$CONF > $RES
                    rm $CONF
                    
                fi

            done

        done

    done

done
