#!/bin/bash

# Part 1: Initial Setup and File Transfer
## Change directory
cd 1_process_movement_file/ || exit

## Remove the old host key from the known_hosts file
#ssh-keygen -R "$HOST"

## Attempt to connect and fetch the new host key
ssh-keyscan -H "$HOST" >> ~/.ssh/known_hosts

## Add a delay
sleep 5

## Run the expect script to perform the sftp transfer
echo "Starting sftp file transfer..."
expect sftp_file_transfer.expect "$PASS" "$USER" "$HOST" "$REMOTEDIR" "$YEAR" "$PRODUCT_GROUP" "$TMPDIR" "$PRODUCT_MODULE"

## Verify the file transfer
echo "Contents of TMPDIR after sftp transfer:"
ls -lh "$TMPDIR"

# Part 2: Import Data into SQLite Database
## Define the TSV file and SQLite database paths
MOVEMENT_FILE="$TMPDIR/${PRODUCT_MODULE}_$YEAR.tsv"

echo "Creating SQLite database and importing TSV file..."
## Create the SQLite database and run initial setup from external SQL script
sqlite3 "$DB_FILE" < import_and_process.sql

## Use a separate command to import the file with the expanded path
sqlite3 "$DB_FILE" ".mode tabs" ".import \"$MOVEMENT_FILE\" raw_movement"

echo "Creating index on 'prmult'..."
## Create indexes to speed up the update process
sqlite3 "$DB_FILE" "CREATE INDEX idx_prmult ON raw_movement(prmult);"

echo "Adding 'mean_price' column..."
## Add the 'mean_price' column
sqlite3 "$DB_FILE" "ALTER TABLE raw_movement ADD COLUMN mean_price REAL;"

echo "Optimizing PRAGMA settings for bulk updates..."
## Optimize PRAGMA settings for bulk updates
sqlite3 "$DB_FILE" <<EOF
PRAGMA journal_mode = OFF;
PRAGMA synchronous = OFF;
PRAGMA cache_size = 1000000;  -- Adjust based on available memory
PRAGMA temp_store = MEMORY;
PRAGMA locking_mode = EXCLUSIVE;
EOF

echo "Starting batch updates..."
## Batch update in chunks to avoid overwhelming the system
batch_size=10000000  # Adjust based on available memory and system capabilities
total_rows=$(sqlite3 "$DB_FILE" "SELECT COUNT(*) FROM raw_movement;")

for (( offset=0; offset<total_rows; offset+=batch_size ))
do
    echo "Processing batch with offset $offset..."
    sqlite3 "$DB_FILE" <<EOF
BEGIN TRANSACTION;
UPDATE raw_movement
SET mean_price = price / prmult
WHERE prmult != 0
AND rowid IN (SELECT rowid FROM raw_movement LIMIT $batch_size OFFSET $offset);
COMMIT;
EOF
done

echo "Batch updates completed."

echo "Calculating mean mean_price and total_sold..."
## Run the external SQL script to create the summary table
sqlite3 "$DB_FILE" < create_summary.sql

echo "Re-enabling normal settings..."
## Re-enable normal settings
sqlite3 "$DB_FILE" <<EOF
PRAGMA journal_mode = DELETE;
PRAGMA synchronous = FULL;
EOF

## Verify the SQLite database size
echo "SQLite database size:"
ls -lh "$DB_FILE"

## Clean up: Uncomment if you want to remove the temporary directory after the script completes
## rm -rf "$TMPDIR"

## Change directory
cd ../ || exit

echo "Movement file processed."