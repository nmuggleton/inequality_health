#!/bin/bash

# User-specific settings
export USER="u1774743"
export HOST="myfiles.warwick.ac.uk"
export KNOWNHOSTS="/home/wbs/bsstng/.ssh/known_hosts"
export PASS="/home/wbs/bsstng/.config/sftp/credentials.txt"
export LOCALDIR="/storage/wbs/bsstng/inequality"
export REMOTEDIR="/Shared533--BARLEVIN/consumer_panel/kilts_scanner"

## Remove the old host key from the known_hosts file
ssh-keygen -R "$HOST"

## Attempt to connect and fetch the new host key
ssh-keyscan -H "$HOST" >> ~/.ssh/known_hosts