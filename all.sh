#!/bin/bash

module load R
export OMP_NUM_THREADS=8

cd search
./scripts/search.sh
cd ..

cd chimera
./scripts/chimera1.sh
./scripts/chimera2.sh
cd ..

cd cluster
./scripts/cluster.sh
cd ..

cd subsample
./scripts/both.sh
cd ..
