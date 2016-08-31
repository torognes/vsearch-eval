#!/bin/bash -

## Check for dependencies first
list="vsearch usearch usearch8 uchime bwa R perl wget awk bzip2 gzip shasum"
for dependency in ${list} ; do
    if [[ ! $(which ${dependency}) ]] ; then
        echo "ERROR: could not find ${dependency}" 1>&2
        exit 1
    fi
done

# Run checks

cd fastq_parsing
./scripts/fastq_parsing.sh
cd ..

cd chimera
./scripts/chimera1.sh
./scripts/chimera2.sh
cd ..
 
cd search
./scripts/search.sh
cd ..

cd cluster
./scripts/cluster.sh
cd ..

cd subsample
./scripts/run.sh
cd ..

cd merge
./scripts/merge.sh
cd ..

cd derep
./scripts/derep.sh
cd ..

exit 0
