# Process Movement File

This subdirectory contains scripts for the `1_process_movement_file` stage of the data processing pipeline.

## Description

The scripts in this subdirectory are responsible for processing the movement file. This is the first step in the data processing pipeline, preparing the movement data for subsequent stages.

## Requirements

- GCCcore/13.2.0
- SQLite/3.43.1
- Python/3.11.5
- Expect

## Usage

To run the scripts in this subdirectory, you need to be in the `1_process_movement_file` subdirectory. Then, you can activate the Python virtual environment and load the required modules:

```bash
cd /path/to/calculate_price_per_unit/1_process_movement_file
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

- `main.sh`: This script processes the movement file.
- `sftp_file_transfer.expect`: This Expect script is used to perform the sftp file transfer.
- `create_movement_table.sql`: This SQL script creates the movement table in the database.
- `insert_into_movement_table.sql`: This SQL script inserts data into the movement table.

## Note

Please ensure that you have the necessary permissions and environment variables set before running these scripts. The scripts require access to certain directories and databases, which are specified by environment variables.
