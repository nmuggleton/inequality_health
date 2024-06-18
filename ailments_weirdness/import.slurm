#!/bin/bash
#SBATCH --job-name=import_ailments
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=01:00:00

# Change to the required directory
cd /storage/wbs/bsstng || exit

# Load required modules
module purge
module load GCCcore/13.2.0
module load Python/3.11.5

# Create a temporary directory
TMPDIR=$(mktemp -d)
echo "Created temporary directory: $TMPDIR"

# Define the host and user
HOST="myfiles.warwick.ac.uk"
USER="u1774743"

# Remove the old host key from the known_hosts file
ssh-keygen -R $HOST

# Attempt to connect and fetch the new host key
ssh-keyscan -H $HOST >> ~/.ssh/known_hosts

# Run the expect script to perform the sftp transfer
expect << EOF
# Read the password from the file
set password [exec cat /home/wbs/bsstng/.config/sftp/credentials.txt]

# Set a longer timeout to accommodate large file transfers
set timeout 600

# Start the sftp session
spawn sftp u1774743@myfiles.warwick.ac.uk

# Automate the login process
expect "password:"
send "\$password\r"

# Define the list of subdirectories
set years {2011 2012 2013 2014 2015 2016 2017 2018 2019 2020 2021}

# Navigate to the desired directory# Define the list of subdirectories
set years {2011 2012 2013 2014 2015 2016 2017 2018 2019 2020 2021}

                                   # Loop over the subdirectories
foreach year \$years {
  # Navigate to the subdirectory
  expect "sftp>"
  send "cd /Shared533--BARLEVIN/consumer_panel/kilts-PanelViewSurvey-ailments/\$year\r"
  expect "sftp>"
# Change the local directory
                                       send "lcd \$env(TMPDIR)\r"
                                       expect "sftp>"

                                       # Download the files
                                       send "mget *ParsedData.*xlsx\r"
                                       expect {
                                           "sftp>" { send "bye\r"; exp_continue }
                                           timeout { puts "Transfer incomplete, retrying..."; send "mget *ParsedData.*xlsx\r"; exp_continue }
                                       }
                                   }
# End the expect script
expect eof
EOF

# Verify the file transfer
echo "Contents of TMPDIR after sftp transfer:"
ls -lh "$TMPDIR"
