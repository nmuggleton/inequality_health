#!/bin/bash
#SBATCH --time=3:00:00
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --output=out/output_%A_%a.out
#SBATCH --error=err/error_%A_%a.err

module purge
module load GCCcore/13.2.0
module load Python/3.11.5

# Define the product module and group
export SLURM_ARRAY_TASK_ID=$SLURM_ARRAY_TASK_ID

## Change directory
cd "$LOCALDIR"/src/calculate_price_per_unit || exit

## Read the parameters
read -r YEAR PRODUCT_GROUP PRODUCT_MODULE < <(sed -n "${SLURM_ARRAY_TASK_ID}p" params/array.txt)

export YEAR=$YEAR
export PRODUCT_GROUP=$PRODUCT_GROUP
export PRODUCT_MODULE=$PRODUCT_MODULE

echo "Year is $YEAR"
echo "Product group is $PRODUCT_GROUP"
echo "Product module is $PRODUCT_MODULE"

# Create a temporary directory database
# shellcheck disable=SC2155
export TMPDIR=$(mktemp -d)
export DB_FILE="$TMPDIR/tmp.db"

# Activate the Python virtual environment
source "$LOCALDIR"/venv/bin/activate

# Load the required modules
module purge
module load GCCcore/13.2.0
module load Python/3.11.5

# Capture start time
START_TIME=$(date +%s)

# Ensure the script has executable permissions
chmod +x 1_process_movement_file/main.sh
chmod +x 2_process_product_file/main.sh
chmod +x 3_calculate_ppu/main.sh

# Run the scripts and capture their PID
./1_process_movement_file/main.sh
./2_process_product_file/main.sh
./3_calculate_ppu/main.sh

# Capture end time
END_TIME=$(date +%s)

# Calculate elapsed time
ELAPSED_TIME=$(date -u -d "0 $END_TIME seconds - $START_TIME seconds" +"%H:%M:%S")

# Write to output file
echo "$YEAR,$PRODUCT_GROUP,$PRODUCT_MODULE,$ELAPSED_TIME" >> job_times.csv