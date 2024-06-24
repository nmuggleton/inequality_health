#!/bin/bash

# Part 1: Initial Setup and File Transfer
## Change directory
cd 2_process_product_file/ || exit

## Remove the old host key from the known_hosts file
#ssh-keygen -R "$HOST"

## Attempt to connect and fetch the new host key
ssh-keyscan -H "$HOST" >> ~/.ssh/known_hosts

## Add a delay
sleep 5

## Run the expect script to perform the sftp transfer
expect sftp_products.expect "$PASS" "$USER" "$HOST" "$REMOTEDIR"

## Verify the file transfer
echo "Contents of TMPDIR after sftp transfer:"
ls -lh "$TMPDIR"

## Generate a subset of the products file
python generate_products_subset.py

rm "$TMPDIR"/products.tsv

# Part 2: Import Data into SQLite Database

## Define the TSV file and SQLite database paths
SIZE_FILE="$TMPDIR/size1_units.tsv"

## Verify the file exists
if [ -z "$SIZE_FILE" ]; then
  echo "SIZE_FILE environment variable is not set."
  exit 1
fi

if [ -z "$DB_FILE" ]; then
  echo "DB_FILE environment variable is not set."
  exit 1
fi

echo "Creating SQLite database and importing TSV file..."

chmod a+r $SIZE_FILE

## Create the SQLite database and import only the required columns
sqlite3 "$DB_FILE" <<EOF
-- Create the main table with only the required columns
CREATE TABLE IF NOT EXISTS size (
    upc TEXT PRIMARY KEY,
    size1_amount REAL,
    size1_units TEXT
);

.mode tabs
.import "$SIZE_FILE" size

EOF

echo "Data import completed."

## Verify the SQLite database size and contents
echo "SQLite database size:"
ls -lh "$DB_FILE"

cd .. || exit

echo "Script completed successfully."