#!/bin/bash

mkdir -p results

BASE="results/BioMarKs.subsample"
WIDTH=1

TSV=$BASE.tsv
PDF=$BASE.tsv.pdf

if [ ! -e $TSV ]; then

    ./scripts/run.sh

fi

if [ ! -e $PDF ]; then

    Rscript ./scripts/plot.R $TSV data/mean.tsv $WIDTH

fi
