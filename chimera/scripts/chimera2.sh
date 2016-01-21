#!/bin/bash

DIR=data/simm
DB=$DIR/simm_sp.fa
RES=results
OUT=$RES/chimeval.txt

THREADS=8

UCHIME=$(which uchime)
USEARCH=$(which usearch)
VSEARCH=$(which vsearch)

# uchime must be preinstalled
# Available here: http://drive5.com/uchime/uchime_download.html

echo Evaluation of uchime_ref

if [ ! -e $DB ]; then
    mkdir -p data
    cd data
    echo Downloading SIMM dataset
    wget http://www.drive5.com/uchime/simm.tar.gz
    tar xzf simm.tar.gz
    cd ..
fi

for t in - m1 m2 m3 m4 m5 i1 i2 i3 i4 i5; do

    echo
    echo Running programs on dataset $t
    echo

    if [ "$t" == "-" ]; then
        INPUT=$DIR/simm.fa
    else
        INPUT=$DIR/simm.$t.fa
    fi

    if [ ! -e o.$t.chimeras ]; then
        $UCHIME --input $INPUT --db $DB --uchimeout $RES/o.$t.uchimeout --minh 0.28 --mindiv 0.8 ; grep Y$ $RES/o.$t.uchimeout | cut -f2 > $RES/o.$t.chimeras
    fi

    if [ ! -e v.$t.chimeras ]; then
        $VSEARCH --uchime_ref $INPUT --db $DB --strand plus --chimeras $RES/v.$t.chimeras --threads $THREADS
    fi

    if [ ! -e u.$t.chimeras ]; then
        $USEARCH --uchime_ref $INPUT --db $DB --strand plus --chimeras $RES/u.$t.chimeras --threads $THREADS
    fi

done

echo

if [ ! -e $OUT ]; then

    echo -e  "\t__________m=2__________\t__________m=3__________\t__________m=4__________" > $OUT
    echo -ne "Div/Evo\tUSEARCH\tUCHIME\tVSEARCH" >> $OUT
    echo -ne "\tUSEARCH\tUCHIME\tVSEARCH" >> $OUT
    echo -e  "\tUSEARCH\tUCHIME\tVSEARCH" >> $OUT

    for r in 97_99 95_97 90_95; do
        for t in - i1 i2 i3 i4 i5 m1 m2 m3 m4 m5; do
            EXT="$t.chimeras"
            echo -ne "$r$t" >> $OUT
            for m in 2 3 4; do
                echo -ne "\t$(grep -c _m${m}_${r} $RES/u.$EXT)" >> $OUT
                echo -ne "\t$(grep -c _m${m}_${r} $RES/o.$EXT)" >> $OUT
                echo -ne "\t$(grep -c _m${m}_${r} $RES/v.$EXT)" >> $OUT
            done
            echo >> $OUT
        done
        echo >> $OUT
    done
fi

#rm -f $RES/o.* $RES/u.* $RES/v.*

echo Done
