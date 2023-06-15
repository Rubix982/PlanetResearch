# Define function to return timestamp
function Get-Timestamp {
  return "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
}

# Verify that the config file exists
if (-not (Test-Path "config.txt")) {
  Write-Error "$(Get-Timestamp) - ERROR: config.txt file not found"
  exit 1
}

# Read the WINUTILS_URL value from config.txt
$config = Get-Content "config.txt" | ConvertFrom-StringData

# Construct path to log file
$log_file = Join-Path $config.LOG_DIR $config.LOG_FILE

try {
    # Check if the file already exists locally
    if (Test-Path $config.PATH_TO_WINUTILS) {
        # If it is, then log that it is, and move on
        Write-Output "$(Get-Timestamp) - winutils.exe already exists locally" | Out-File $log_file -Append
    } else {
        # Download winutils.exe from remote server
        Invoke-WebRequest -Uri $config.WINUTILS_URL -OutFile $config.PATH_TO_WINUTILS
        Write-Output "$(Get-Timestamp) - Downloaded winutils.exe from $($config.WINUTILS_URL)" | Out-File $log_file -Append
    }

    # Set HADOOP_HOME environment variable
    [Environment]::SetEnvironmentVariable("HADOOP_HOME", $config.PATH_TO_WINUTILS, "User")
    Write-Output "$(Get-Timestamp) - Set HADOOP_HOME to $($config.PATH_TO_WINUTILS)" | Out-File $log_file -Append

    # Add directory to PATH environment variable
    [Environment]::SetEnvironmentVariable("PATH", "$config.PATH_TO_WINUTILS;$env:PATH", "User")
    Write-Output "$(Get-Timestamp) - Added $($config.PATH_TO_WINUTILS) to PATH environment variable" | Out-File $log_file -Append
} catch {
    # Log a possible exception that could happen
    Write-Output "$(Get-Timestamp) - ERROR: $($_.Exception.Message)" | Out-File $log_file -Append
}