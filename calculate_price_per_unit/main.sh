#!/bin/bash

# User-specific settings
export USER="u1774743"
export HOST="myfiles.warwick.ac.uk"
export KNOWNHOSTS="/home/wbs/bsstng/.ssh/known_hosts"
export PASS="/home/wbs/bsstng/.config/sftp/credentials.txt"
export LOCALDIR="/storage/wbs/bsstng/inequality"
export REMOTEDIR="/Shared533--BARLEVIN/consumer_panel/kilts_scanner"

## Remove the old host key from the known_hosts file
ssh-keygen -R "$HOST"

## Attempt to connect and fetch the new host key
ssh-keyscan -H "$HOST" >> ~/.ssh/known_hosts

## Run the expect script to perform the sftp transfer.
#echo "Starting sftp file transfer..."
expect sftp_array_transfer.expect "$PASS" "$USER" "$HOST" "$REMOTEDIR"

## Load the necessary modules and run the R script
module purge
module load GCC/13.2.0
module load OpenMPI/4.1.6
module load R/4.3.3

## Run the R script to create the array
cd $LOCALDIR/src/calculate_price_per_unit || exit
Rscript make_array.R

# Run the slurm script
## Check if the output file exists
if [ ! -f job_times.csv ]; then
    # If not, create it and write the header line
    echo "YEAR,PRODUCT_GROUP,PRODUCT_MODULE,ELAPSED_TIME" > job_times.csv
fi

## Define the range of arrays for each job
START=1
END=$(wc -l < params/array.txt)
STEP=500

## Loop over the range and submit a job for each subset of tasks
for ((i=START; i<=END; i+=STEP)); do
    j=$((i+STEP-1))
    if ((j>END)); then
        j=$END
    fi

    ## Submit the job with the array option set to the current range of tasks
    sbatch --wait --array="$i"-"$j" data_processing_pipeline.slurm

done

## Clean up
#rm params/*.txt
#rm job_times.csv
