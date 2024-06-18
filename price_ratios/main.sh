#!/bin/bash

# User-specific settings
export USER="u1774743"
export HOST="myfiles.warwick.ac.uk"
export PASS="/home/wbs/bsstng/.config/sftp/credentials.txt"
export LOCALDIR="/storage/wbs/bsstng/inequality"
export REMOTEDIR="/Shared533--BARLEVIN/consumer_panel/kilts_scanner"

# Import array for sbatch
## Remove the old host key from the known_hosts file
ssh-keygen -R "$HOST"

## Attempt to connect and fetch the new host key
ssh-keyscan -H "$HOST" >> ~/.ssh/known_hosts

## Run the expect script to perform the sftp transfer
echo "Starting sftp file transfer..."
expect sftp_array_transfer.expect "$PASS" "$USER" "$HOST" "$REMOTEDIR"

# Load the necessary modules and run the R script
module purge
module load GCC/13.2.0
module load OpenMPI/4.1.6
module load R/4.3.3

R <<EOF

library(data.table)
library(stringr)

files <- fread('output.txt', header = F)

files <- files[!str_detect(V1, 'Annual_Files')]

files[, year := str_extract(V1, '\\d{4}')]
files[, product_group := str_extract(V1, '\\d{4}(?=_)')]
files[, product_module := str_extract(V1, '\\d{4}(?=_\\d{4}.tsv)')]

write.table(
  files[, c('year', 'product_group', 'product_module')],
  file = 'array.txt',
  row.names = F,
  col.names = F,
  sep = '\t',
  quote = F
)

EOF

sbatch data_processing_pipeline.slurm

rm output.txt array.txt
