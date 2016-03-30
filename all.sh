#!/bin/bash -

## Check for dependencies first
list="vsearch usearch usearch8 uchime pear bwa R perl wget awk bzip2 gzip md5sum"
for dependency in ${list} ; do
    if [[ ! $(which ${dependency}) ]] ; then
        echo "ERROR: could not find ${dependency}" 1>&2
        exit 1
    fi
done

## Run independent tests first
for script in ./*/scripts/fastq_parsing.sh ; do
    echo "Run $(basename ${script})"
    (cd ${script/scripts*/} ; bash ${script/*scripts/\.\/scripts})
done

## Some tests are not independent and must run in a specific order
cd chimera
./scripts/chimera1.sh
./scripts/chimera2.sh
cd ..
 
cd cluster
./scripts/cluster.sh
cd ..

cd subsample
./scripts/subsample.sh
cd ..

cd merge
./scripts/merge.sh
cd ..

exit 0
