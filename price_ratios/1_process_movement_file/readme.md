# 1_process_movement_file

This directory contains scripts and resources related to processing movement 
data for a given product category in a given year.

## Main Components

- `main.sh`: This is the primary script that initiates the data processing  
  pipeline. It sets up the environment, manages file transfers, and controls the
  execution of other scripts.

- `sftp_file_transfer.expect`: This is an Expect script that automates the 
  process of transferring files via SFTP. It reads the password from a file, 
  logs into the SFTP server, navigates to the desired directory, and downloads
  the necessary files.

## Workflow
1. The `main.sh` script starts by setting up the environment and defining 
   necessary variables.

2. It then removes the old host key for the SFTP server from the known_hosts 
   file and fetches the new host key.

3. The `sftp_file_transfer.expect` script is called to perform the SFTP file
   transfer. It logs into the SFTP server, navigates to the directory containing
   the movement data, and downloads the necessary files.

4. After the file transfer, the `main.sh` script verifies the transfer by
   listing the contents of the temporary directory.

5. The script then imports the downloaded data into a SQLite database, creates 
   necessary indexes, and performs batch updates to calculate the price per 
   unit.

6. Finally, the script verifies the import and calculations, and cleans up the
   temporary directory.

## Usage

To use these scripts, navigate to the `1_process_movement_file` directory and
run the `main.sh` script. Make sure to set the necessary environment variables
before running the script.

```bash
cd 1_process_movement_file/
./main.sh