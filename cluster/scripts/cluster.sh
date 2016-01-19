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

echo Cluster

./scripts/run.sh

date

echo Create confusion tables

./scripts/confusion.sh

date

echo Compute metrics

./scripts/metrics1.sh

date

echo Reformat metrics

./scripts/metrics2.sh

date

echo Plot

./scripts/plot.sh

date

echo Done
