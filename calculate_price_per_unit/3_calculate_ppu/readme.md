# Calculate price per unit

This subdirectory contains scripts for the `3_calculate_ppu` stage of the data processing pipeline.

## Description

The scripts in this subdirectory are responsible for calculating the price per unit for each product.
This is the final step in the data processing pipeline, providing the key metric for comparing prices across different products and time periods.

## Requirements

- GCCcore/13.2.0
- SQLite/3.43.1
- Python/3.11.5

## Usage

To run the scripts in this subdirectory, you need to be in the `3_calculate_ppu` subdirectory. Then, you can activate the Python virtual environment and load the required modules:

```bash
cd /path/to/calculate_price_per_unit/3_calculate_ppu
source /path/to/venv/bin/activate
module purge
module load GCCcore/13.2.0
module load SQLite/3.43.1
module load Python/3.11.5
module load Expect
```

After the environment is set up, you can run the script:

```bash
source main.sh
```

## Files

- `main.sh`: This script calculates the price per unit.
- `sftp_array_transfer.expect`: This Expect script is used to perform the sftp file transfer.

## Note

Please ensure that you have the necessary permissions and environment variables set before running these scripts.
The scripts require access to certain directories and databases, which are specified by environment variables.
