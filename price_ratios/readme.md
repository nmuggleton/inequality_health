# Calculate Price Per Unit

This directory contains scripts for the `calculate_price_per_unit` stage of the data processing pipeline.

## Description

The scripts in this directory are responsible for calculating the price per unit for each product in the dataset. This is a crucial step in the data processing pipeline, as it allows for the comparison of prices across different products and time periods.

## Requirements

- GCCcore/13.2.0
- SQLite/3.43.1
- Python/3.11.5

## Usage

To run the scripts in this directory, you need to be in the `calculate_price_per_unit` directory. Then, you can activate the Python virtual environment and load the required modules:

```bash
cd /path/to/calculate_price_per_unit
source /path/to/venv/bin/activate
module purge
module load GCCcore/13.2.0
module load SQLite/3.43.1
module load Python/3.11.5
```

After the environment is set up, you can run the scripts:

```bash
source 1_process_movement_file/main.sh
source 2_process_product_file/main.sh
source 3_calculate_ppu/main.sh
```

## Files

- `1_process_movement_file/main.sh`: This script processes the movement file.
- `2_process_product_file/main.sh`: This script processes the product file.
- `3_calculate_ppu/main.sh`: This script calculates the price per unit.

## Note

Please ensure that you have the necessary permissions and environment variables set before running these scripts. The scripts require access to certain directories and databases, which are specified by environment variables.
