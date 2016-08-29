#!/bin/bash -

## Print a header
SCRIPT_NAME="subsampling comparison"
LINE=$(printf "%076s\n" | tr " " "-")
printf "# %s %s\n" "${LINE:${#SCRIPT_NAME}}" "${SCRIPT_NAME}"

failure () {
    printf "FAIL: ${1}\n"
    exit -1
}

## Check for dependencies (usearch, vsearch)
VSEARCH=$(which vsearch)
DESCRIPTION="vsearch binary not found"
[[ "${VSEARCH}" ]] || failure "${DESCRIPTION}"
USEARCH8=$(which usearch8)
DESCRIPTION="usearch binary not found"
[[ "${USEARCH8}" ]] || failure "${DESCRIPTION}"

## Get data (check first)
DATA="../data"
mkdir -p "${DATA}"
FASTA="TARA_V9_264_samples.fas"
URL="https://elwe.rhrk.uni-kl.de/outgoing/${FASTA}"
[[ -s "${DATA}/${FASTA}" ]] || (cd ${DATA}/ ; wget "${URL}")

## Subsample once to avoid usearch memory limit
INITIAL_PERCENTAGE="10.0"
INPUT=$(mktemp)
${VSEARCH} \
    --fastx_subsample "${DATA}/${FASTA}" \
    --fastaout "${INPUT}" \
    --randseed 1 \
    --sample_pct "${INITIAL_PERCENTAGE}" \
    --sizein \
    --sizeout > /dev/null
NOMINAL_SIZE=$(head -n 1 "${INPUT}" | cut -d "=" -f 2  | tr -d ";")

## Subsample 10,000 times with vsearch and usearch
TMP_FASTA=$(mktemp)
for PERCENTAGE in 1 5 10 20 50 ; do
    LOG="${TARA/.fas/.subsample}_${PERCENTAGE/.0/_head}.log"
    for i in {1..10000} ; do
        ${VSEARCH} \
            --fastx_subsample "${INPUT}" \
            --fastaout "${TMP_FASTA}" \
            --randseed "${i}" \
            --sample_pct "${PERCENTAGE}" \
            --sizein \
            --sizeout > /dev/null

        SIZE_VSEARCH=$(head -n 1 "${TMP_FASTA}" | cut -d "=" -f 2 | tr -d ";")

        ${USEARCH8} \
            -fastx_subsample "${INPUT}" \
            -fastaout "${TMP_FASTA}" \
            -randseed "${i}" \
            -sample_pct "${PERCENTAGE}" \
            -sizein \
            -sizeout > /dev/null

        SIZE_USEARCH8=$(head -n 1 "${TMP_FASTA}" | cut -d "=" -f 2 | tr -d ";")

        echo -e "${PERCENTAGE}\t${NOMINAL_SIZE}\t${SEED}\t${SIZE_VSEARCH}\t${SIZE_USEARCH8}"
    done >> ${LOG}
done
    
rm "${TMP_FASTA}" "${INPUT}"

exit 0

## TODO produce plot (launch a R script, that R script is going to check for dependencies)
