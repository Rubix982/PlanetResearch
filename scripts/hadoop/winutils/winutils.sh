#!/bin/bash

# Define function to return timestamp
function get_timestamp() {
  echo "$(date +'%Y-%m-%d %H:%M:%S')"
}

current_script_dir="$(pwd)/scripts/hadoop/winutils/"

# Read the WINUTILS_URL value from config.txt
source "$current_script_dir/config.txt"

# Log file path
log_file="$LOG_DIR/$LOG_FILE"

# Filepath to save to
path_to_winutils="$(pwd)/bin/$FILE_NAME"

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Exit the script if any command fails
set -e

# Exit the script if any command in a pipeline fails
set -o pipefail

# Trap any errors and log them to the log file
trap 'echo "$(get_timestamp) - ERROR: $BASH_COMMAND failed with exit code $?" >> "$log_file"' ERR

# Check if the file already exists locally
if [ -f "$path_to_winutils" ]; then
  echo "$(get_timestamp) - winutils.exe already exists locally" >> "$log_file"
else
  # Download winutils.exe from remote server
  curl -o "$path_to_winutils" "$WINUTILS_URL"
  echo "$(get_timestamp) - Downloaded winutils.exe from $WINUTILS_URL" >> "$log_file"
fi

# Set HADOOP_HOME environment variable
export HADOOP_HOME="$path_to_winutils"
echo "$(get_timestamp) - Set HADOOP_HOME to $path_to_winutils" >> "$log_file"

# Add directory to PATH environment variable
export PATH="$path_to_winutils:$PATH"
echo "$(get_timestamp) - Added $path_to_winutils to PATH environment variable" >> "$log_file"