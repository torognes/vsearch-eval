#!/bin/bash -

## Print a header
SCRIPT_NAME="Fasta parsing"
line=$(printf "%076s\n" | tr " " "-")
printf "# %s %s\n" "${line:${#SCRIPT_NAME}}" "${SCRIPT_NAME}"

## Declare a color code for test results
RED="\033[1;31m"
GREEN="\033[1;32m"
NO_COLOR="\033[0m"

failure () {
    printf "${RED}FAIL${NO_COLOR}: ${1}\n"
    # exit -1
}

success () {
    printf "${GREEN}PASS${NO_COLOR}: ${1}\n"
}

## Is vsearch installed?
VSEARCH=$(which vsearch)
DESCRIPTION="check if vsearch is in the PATH"
[[ "${VSEARCH}" ]] && success "${DESCRIPTION}" || failure "${DESCRIPTION}"

## Is usearch (7) installed?
USEARCH=$(which usearch)
DESCRIPTION="check if usearch is in the PATH"
[[ "${USEARCH}" ]] && success "${DESCRIPTION}" || failure "${DESCRIPTION}"

## Is usearch8 installed?
USEARCH8=$(which usearch8)
DESCRIPTION="check if usearch8 is in the PATH"
[[ "${USEARCH8}" ]] && success "${DESCRIPTION}" || failure "${DESCRIPTION}"


#*****************************************************************************#
#                                                                             #
#               Fastq valid and invalid examples (Cocks, 2010)                #
#                                                                             #
#*****************************************************************************#

## Download data (doi: 10.1093/nar/gkp1137), if not already present
get_data () {
    DATASET="nar-02248-d-2009-File005.gz"
    wget -q http://nar.oxfordjournals.org/content/suppl/2009/12/16/gkp1137.DC1/${DATASET}
    tar zxf ${DATASET}
    rm ${DATASET}
}
mkdir -p data
cd data && [[ $(ls *.fastq 2>/dev/null) ]] || get_data

# --------------------------------------------------------------------- vsearch

## Return status should be zero (success)
find . -name "*.fastq" ! -name "error*" -print | \
    while read f ; do
        DESCRIPTION="vsearch: $(basename ${f}) is a valid file"
        "${VSEARCH}" --fastq_chars "${f}" 2> /dev/null > /dev/null && \
            success  "${DESCRIPTION}" || \
                failure "${DESCRIPTION}"
    done

## Return status should be !zero (failure)
find . -name "error*.fastq" -print | \
    while read f ; do
        DESCRIPTION="vsearch: $(basename ${f}) is an invalid file"
        "${VSEARCH}" --fastq_chars "${f}" 2> /dev/null > /dev/null && \
            failure "${DESCRIPTION}" || \
                success  "${DESCRIPTION}"
    done

# -------------------------------------------------------------------- usearch

## Return status should be zero (success)
find . -name "*.fastq" ! -name "error*" -print | \
    while read f ; do
        DESCRIPTION="usearch: $(basename ${f}) is a valid file"
        "${USEARCH}" -fastq_chars "${f}" 2> /dev/null > /dev/null && \
            success  "${DESCRIPTION}" || \
                failure "${DESCRIPTION}"
    done

## Return status should be !zero (failure)
find . -name "error*.fastq" -print | \
    while read f ; do
        DESCRIPTION="usearch: $(basename ${f}) is an invalid file"
        "${USEARCH}" -fastq_chars "${f}" 2> /dev/null > /dev/null && \
            failure "${DESCRIPTION}" || \
                success  "${DESCRIPTION}"
    done

# -------------------------------------------------------------------- usearch8

## Return status should be zero (success)
find . -name "*.fastq" ! -name "error*" -print | \
    while read f ; do
        DESCRIPTION="usearch8: $(basename ${f}) is a valid file"
        "${USEARCH8}" -fastq_chars "${f}" 2> /dev/null > /dev/null && \
            success  "${DESCRIPTION}" || \
                failure "${DESCRIPTION}"
    done

## Return status should be !zero (failure)
find . -name "error*.fastq" -print | \
    while read f ; do
        DESCRIPTION="usearch8: $(basename ${f}) is an invalid file"
        "${USEARCH8}" -fastq_chars "${f}" 2> /dev/null > /dev/null && \
            failure "${DESCRIPTION}" || \
                success  "${DESCRIPTION}"
    done

exit 0
