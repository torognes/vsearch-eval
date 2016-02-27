#!/bin/bash -

## Check for dependencies first
list="vsearch usearch usearch8 uchime pear bwa R perl wget awk bzip2 gzip"
for dependency in ${list} ; do
    if [[ ! $(which ${dependency}) ]] ; then
        echo "ERROR: could not find ${dependency}" 1>&2
        exit 1
    fi
done

## Run all tests
for script in ./*/scripts/*.sh ; do
    echo "Run $(basename $script)"
    bash "${script}"
done

exit 0
