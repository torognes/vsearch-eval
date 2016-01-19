#!/bin/bash

if [ ! -e results/even/clustering_metrics_medians.pdf ]; then

    cd results/even
    R CMD BATCH ../../scripts/plot.R
    cd ../..

fi

if [ ! -e results/uneven/clustering_metrics_medians.pdf ]; then

    cd results/uneven
    R CMD BATCH ../../scripts/plot.R
    cd ../..

fi
