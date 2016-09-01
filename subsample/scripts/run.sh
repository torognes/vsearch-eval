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

## Preparation (check first)
RESULTS="results"
DATA="data"
mkdir -p "${DATA}" "${RESULTS}"
FASTA="TARA_V9_264_samples.fas"
URL="https://elwe.rhrk.uni-kl.de/outgoing/${FASTA}"
[[ -s "${DATA}/${FASTA}" ]] || (cd ${DATA}/ ; wget -nv "${URL}")

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

## Subsample 10,000 times with vsearch and usearch8
TMP_FASTA=$(mktemp)
REPEATS=10000
for PERCENTAGE in 1 5 15 25 50 ; do
    LOG="${RESULTS}/${FASTA/.fas/.subsample}_${PERCENTAGE}_head.log"
    echo -e "percentage\tnominal_size\tseed\tsize_vsearch\tsize_usearch8" > ${LOG}
    for ((i=1; i<=REPEATS; i++)) ; do
        echo "loop ${PERCENTAGE}%: ${i}/${REPEATS}"
        ${VSEARCH} \
            --fastx_subsample "${INPUT}" \
            --fastaout "${TMP_FASTA}" \
            --randseed "${i}" \
            --sample_pct "${PERCENTAGE}" \
            --sizein \
            --sizeout \
            --quiet 2> /dev/null
        SIZE_VSEARCH=$(head -n 1 "${TMP_FASTA}" | cut -d "=" -f 2 | tr -d ";")

        ${USEARCH8} \
            -fastx_subsample "${INPUT}" \
            -fastaout "${TMP_FASTA}" \
            -randseed "${i}" \
            -sample_pct "${PERCENTAGE}" \
            -sizein \
            -sizeout \
            -quiet
        SIZE_USEARCH8=$(head -n 1 "${TMP_FASTA}" | cut -d "=" -f 2 | tr -d ";")

        echo -e "${PERCENTAGE}\t${NOMINAL_SIZE}\t${i}\t${SIZE_VSEARCH}\t${SIZE_USEARCH8}" >> ${LOG}
    done
done

rm "${TMP_FASTA}" "${INPUT}"

## Produce plots
Rscript scripts/plot.R

exit 0
