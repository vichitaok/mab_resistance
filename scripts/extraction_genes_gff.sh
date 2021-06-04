#!/bin/bash

#------------------------------------------------------------------------------
# Extract sequences from genes names list
# Organism: Mycobacterium abscessus ssp. abscessus
#------------------------------------------------------------------------------

set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes
set -u           # aborts the script if a variable’s value is unset


# Shell à utiliser pour l'exécution du job
#$ -S /bin/bash

# Job name
#$ -N getfasta

# Export every environment variable
#$ -V

# Standard output
#$ -o /work_projet/mab_resistance/log/reference/

# Error output 
#$ -e /work_projet/mab_resistance/log/reference/

# Running from the script directory
#$ -cwd

# Nb threads 4 CPUs
#$ -pe thread 4


# list of genes
list=/work_projet/mab_resistance/tables/liste_genes_resistance.txt

# annotation file
gff=/work_projet/mab_resistance/DATA/REFERENCE/Mycobacterium_abscessus_ATCC_19977_gff_v4.gff

# genome (fasta)
fasta=/work_projet/mab_resistance/DATA/REFERENCE/Mycobacterium_abscessus_ATCC_19977_genome_v4.fasta


mkdir -p /work_projet/mab_resistance/ANALYSIS/REFERENCE/genes_resistance


# conda activate bedtools
conda activate bedtools-2.29.0

# Extraction genomic sequences
for gene in `cat ${list}` ; do 
	gene_gff=$(grep ${gene} ${gff}) 
	bedtools getfasta -fi ${fasta} -bed ${gene_gff} > /work_projet/mab_resistance/ANALYSIS/REFERENCE/genes_resistance/${gene}.fasta
done


# conda deactivate
conda deactivate



