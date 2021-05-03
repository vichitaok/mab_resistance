#!/bin/bash

#------------------------------------------------------------------------------
# Download genomic.fna from NCBI
# Organism: Mycobacterium abscessus ssp. abscessus
#------------------------------------------------------------------------------

set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes
set -u           # aborts the script if a variable’s value is unset

# folder for the downloaded genomes
mkdir -p /work_projet/mab_resistance/GENOMES_NCBI
mkdir -p /work_projet/mab_resistance/log

# table exported from NCBI
table=/work_projet/mab_resistance/tables/ncbi_abscessus_ssp_abscessus.csv

# Remove the "" in the .csv file
#Collect and modify the FTP URLs of the table to point to the _genomic.fna.gz files (remove the first line (RefSeq FTP), separation in 2 blocks, then reconstruction with addition of the 2nd block)
ftpR=$(sed 's/"//g' ${table} | cut -f 16 -d "," | grep -v 'RefSeq' | sed -r 's|(ftp://ftp.ncbi.nlm.nih.gov/genomes/all/.+/)(GCF_.+)|\1\2/\2_genomic.fna.gz|')

# Download the genomes using the FTP URLs created
for ftp in ${ftpR}
do
	wget ${ftp} -p /work_projet/mab_resistance/GENOMES_NCBI
done


