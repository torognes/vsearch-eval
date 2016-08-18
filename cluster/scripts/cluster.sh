#!/bin/bash

# Assume that current directory is at the top,
# with scripts, data and results below

date

echo Make dirs

mkdir -p ./results/even
mkdir -p ./results/uneven

echo Download files

./scripts/download.sh

date

echo Dereplicate

./scripts/derep.sh

date

echo Perform taxonomic classification

./scripts/tax.sh

date

echo Shuffle

./scripts/shuffle.sh

date

echo Cluster, make confusion tables and evaluate

./scripts/run.sh

date

echo Collect clustering metrics

./scripts/metrics.sh

date

echo Plot

./scripts/plot.sh

date

echo Collect timing info

./scripts/time.sh

date

echo Plot timing

Rscript scripts/timeplot.R

date

echo Done
