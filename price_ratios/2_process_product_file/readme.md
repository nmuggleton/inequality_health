# Process products

This subdirectory contains scripts for the `2_process_product_file` stage of the data processing pipeline.

## Description

The scripts in this subdirectory are responsible for processing the product file. This step in the data processing pipeline prepares the product data for the subsequent calculation of the price per unit.

## Requirements

- GCCcore/13.2.0
- SQLite/3.43.1
- Python/3.11.5

## Usage

To run the scripts in this subdirectory, you need to be in the `2_process_product_file` subdirectory. Then, you can activate the Python virtual environment and load the required modules:

```bash
cd /path/to/calculate_price_per_unit/2_process_product_file
source /path/to/venv/bin/activate
module purge
module load GCCcore/13.2.0
module load SQLite/3.43.1
module load Python/3.11.5
```

After the environment is set up, you can run the script:

```bash
source main.sh
```

## Files

- `main.sh`: This script processes the product file.

## Note

Please ensure that you have the necessary permissions and environment variables set before running these scripts. The scripts require access to certain directories and databases, which are specified by environment variables.
