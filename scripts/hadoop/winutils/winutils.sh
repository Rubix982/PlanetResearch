#!/bin/bash

# Define function to return timestamp
function get_timestamp() {
  echo "$(date +'%Y-%m-%d %H:%M:%S')"
}

# Read the WINUTILS_URL value from config.txt
source config.txt

# Log file path
log_file="$LOG_DIR/$LOG_FILE"

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Exit the script if any command fails
set -e

# Exit the script if any command in a pipeline fails
set -o pipefail

# Trap any errors and log them to the log file
trap 'echo "$(get_timestamp) - ERROR: $BASH_COMMAND failed with exit code $?" >> "$log_file"' ERR

# Check if the file already exists locally
if [ -f "$PATH_TO_WINUTILS" ]; then
  echo "$(get_timestamp) - winutils.exe already exists locally" >> "$log_file"
else
  # Download winutils.exe from remote server
  curl -o "$PATH_TO_WINUTILS" "$WINUTILS_URL"
  echo "$(get_timestamp) - Downloaded winutils.exe from $WINUTILS_URL" >> "$log_file"
fi

# Set HADOOP_HOME environment variable
export HADOOP_HOME="$PATH_TO_WINUTILS"
echo "$(get_timestamp) - Set HADOOP_HOME to $PATH_TO_WINUTILS" >> "$log_file"

# Add directory to PATH environment variable
export PATH="$PATH_TO_WINUTILS:$PATH"
echo "$(get_timestamp) - Added $PATH_TO_WINUTILS to PATH environment variable" >> "$log_file"