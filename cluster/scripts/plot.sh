#!/bin/bash

if [ ! -e results/even/clustering_metrics_medians.pdf ]; then

    cd results/even
    Rscript ../../scripts/plot.R
    cd ../..

fi

if [ ! -e results/uneven/clustering_metrics_medians.pdf ]; then

    cd results/uneven
    Rscript ../../scripts/plot.R
    cd ../..

fi
