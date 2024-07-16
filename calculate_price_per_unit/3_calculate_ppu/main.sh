#!/bin/bash

# Part 1: Initial Setup and File Transfer
## Change directory
cd 3_calculate_ppu/ || exit

sqlite3 "$DB_FILE" <<EOF
.read standardise_units.sql
EOF

# Part 2: Exporting the Output Table
# Export the output table to a .tsv file
mkdir -p "${TMPDIR}/calculations/${YEAR}/${PRODUCT_GROUP}/"
echo -e ".mode tabs\n.headers on\nSELECT * FROM standardised_output;" \
    | sqlite3 "$DB_FILE" > "${TMPDIR}/calculations/${YEAR}/${PRODUCT_GROUP}/${PRODUCT_MODULE}_${YEAR}.csv"

## Remove the old host key from the known_hosts file
ssh-keygen -R "$HOST"

## Attempt to connect and fetch the new host key
ssh-keyscan -H "$HOST" >> ~/.ssh/known_hosts

# Call the expect script to upload the .tsv file
expect sftp_upload.expect "$PASS" "$USER" "$HOST" "$REMOTEDIR" "$TMPDIR"

cd .. || exit

echo "Script completed successfully."