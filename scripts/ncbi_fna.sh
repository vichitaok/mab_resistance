#!/bin/bash

#------------------------------------------------------------------------------
# Download genomic.fna from NCBI
# Organism: Mycobacterium abscessus ssp. abscessus
#------------------------------------------------------------------------------

# folder for the downloaded genomes
mkdir -p /work_projet/mab_resistance/GENOMES_NCBI

# table exported from NCBI
table=/work_projet/mab_resistance/tables/ncbi_abscessus_ssp_abscessus.csv

# Collect and modify the FTP URLs of the table to point to the _genomic.fna.gz files (separation in 2 blocks, then reconstruction with addition of the 2nd block)
ftpR=$(cut -f 16 -d "," ${table} | grep -v '^#' | sed -r 's|(ftp://ftp.ncbi.nlm.nih.gov/genomes/all/.+/)(GCF_.+)|\1\2/\2_genomic.fna.gz|')

# Download the genomes using the FTP URLs created
for ftp in ${ftpR}
do
	wget ${ftp} -p /work_projet/mab_resistance/GENOMES_NCBI
done


