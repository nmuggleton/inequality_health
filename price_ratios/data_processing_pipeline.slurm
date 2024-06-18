#!/bin/bash
#SBATCH --time=3:00:00
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --output=out/output_%A_%a.err
#SBATCH --error=err/error_%A_%a.err
#SBATCH --array=1-500

# Try array=1-4154
# User-specific settings
export USER="u1774743"
export HOST="myfiles.warwick.ac.uk"
export PASS="/home/wbs/bsstng/.config/sftp/credentials.txt"
export LOCALDIR="/storage/wbs/bsstng/inequality"
export REMOTEDIR="/Shared533--BARLEVIN/consumer_panel/kilts_scanner"

# Define the product module and group
read -r YEAR PRODUCT_GROUP PRODUCT_MODULE < <(sed -n "${SLURM_ARRAY_TASK_ID}p" array.txt)

# Create a temporary directory database
# shellcheck disable=SC2155
export TMPDIR=$(mktemp -d)
export DB_FILE="$TMPDIR/tmp.db"

export YEAR="2006"
export PRODUCT_GROUP="0501"
export PRODUCT_MODULE="1272"

# Create a temporary directory database
# shellcheck disable=SC2155
export TMPDIR=$(mktemp -d)
export DB_FILE="$TMPDIR/tmp.db"

## Change directory
cd "$LOCALDIR"/src/calculate_price_per_unit || exit

# Activate the Python virtual environment
source "$LOCALDIR"/venv/bin/activate

## Load required modules
module purge
module load GCCcore/13.2.0
module load SQLite/3.43.1
module load Python/3.11.5

# Run the scripts
source 1_process_movement_file/main.sh
source 2_process_product_file/main.sh
source 3_calculate_ppu/main.sh