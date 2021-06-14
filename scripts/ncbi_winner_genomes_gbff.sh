#!/bin/bash

#------------------------------------------------------------------------------
# Download NCBI genomic.gff from list of winning genomes
# Organism: Mycobacterium abscessus ssp. abscessus
#------------------------------------------------------------------------------

set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes
set -u           # aborts the script if a variable’s value is unset

# folder for the downloaded genomes
mkdir -p /work_projet/mab_resistance/DATA/GENOMES_NCBI/gbff

# table exported from NCBI
table=/work_projet/mab_resistance/tables/prokaryotes.csv

# list of winning genomes
list=$(sed 's/_genomic.fna//g' /work_projet/mab_resistance/tables/ncbi_winner_genomes.txt)

# new table (winning genomes)
for genome in ${list}
do
    echo "${genome}"
    grep ${genome} ${table} >> /work_projet/mab_resistance/tables/ncbi_winner_genomes.csv
done

table_winner=/work_projet/mab_resistance/tables/ncbi_winner_genomes.csv

# Remove the "" in the .csv file
#Collect and modify the FTP URLs of the table to point to the _genomic.fna.gz files (remove the first line (RefSeq FTP), separation in 2 blocks, then reconstruction with addition of the 2nd block)
ftpR=$(sed 's/"//g' ${table_winner} | cut -f 16 -d "," | grep -Ev 'RefSeq|^$' | sed -r 's|(ftp://ftp.ncbi.nlm.nih.gov/genomes/all/.+/)(GCF_.+)|\1\2/\2_genomic.gbff.gz|')


# Download the genomes using the FTP URLs created
for ftp in ${ftpR}
do
    echo "${ftp}"
    filename=$(echo ${ftp} | cut -f 11 -d "/")
    
    if [[ -e /work_projet/mab_resistance/DATA/GENOMES_NCBI/gbff/${filename} ]]
    then
        echo "ERROR: Input file '${filename}' already exists"
    fi
    
	wget ${ftp} -P /work_projet/mab_resistance/DATA/GENOMES_NCBI/gbff
done


