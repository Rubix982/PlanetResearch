# Configurations
$DebugPreference = "Continue"
$VerbosePreference = "Continue"

# Define function to return timestamp
function Get-Timestamp
{
    return "$( Get-Date -Format 'yyyy-MM-dd HH:mm:ss' )"
}

# Define function to write debug messages with timestamp
function Write-TimeStampedDebugMessage($message)
{
    Write-Debug "$( Get-Timestamp ) - $message"
}

# Greet user
Write-TimeStampedDebugMessage "Starting winutils.ps1"

# Specify script path
$script_path = (Join-Path (Get-Location).Path "scripts")
Write-TimeStampedDebugMessage "Script path: $script_path"

# Bin directory path
$bin_dir_path = (Join-Path (Get-Location).Path "bin")
Write-TimeStampedDebugMessage "Bin directory path: $bin_dir_path"

# Specify project-script path
$project_script_path = (Join-Path $script_path "hadoop")
Write-TimeStampedDebugMessage "Project script path: $project_script_path"

# Provide path relative to project to the current working directory
$current_script_dir = (Join-Path $project_script_path "winutils")
Write-TimeStampedDebugMessage "Current script directory: $current_script_dir"

# Config file path
$config_file_path = (Join-Path $current_script_dir "config.txt")
Write-TimeStampedDebugMessage "Config file path: $config_file_path"

# Verify that the config file exists
if (-not(Test-Path $config_file_path))
{
    Write-Error "$( Get-Timestamp ) - ERROR: config.txt file not found"
    exit 1
}

# Read the WINUTILS_URL value from config.txt
$config = Get-Content $config_file_path  | ConvertFrom-StringData
Write-TimeStampedDebugMessage "Config file loaded successfully"

# Construct path to log file
$log_dir_path = Join-Path $script_path $config.LOG_DIR
Write-TimeStampedDebugMessage "Log directory path: $log_dir_path"

# Winutils file path
$winutils_file_path = (Join-Path $bin_dir_path $config.FILE_NAME)
Write-TimeStampedDebugMessage "Winutils file path: $winutils_file_path"

# Create log directory if it doesn't exist
if (-not(Test-Path $log_dir_path))
{
    Write-TimeStampedDebugMessage "Creating log directory"
    New-Item -ItemType Directory -Path $log_dir_path
}

# Build log file name
$log_file_name = "$((Get-Timestamp).Replace(' ', '_').Replace(':', '-') )_hadoop.log"
Write-TimeStampedDebugMessage "Log file name: $log_file_name"

# Construct path to log file
$log_file_path = Join-Path $log_dir_path $log_file_name
Write-TimeStampedDebugMessage "Log file path: $log_file_path"

try
{
    # Check if the file already exists locally
    if (Test-Path $winutils_file_path)
    {
        # If it is, then log that it is, and move on
        Write-TimeStampedDebugMessage "winutils.exe already exists locally" | Out-File $log_file_path -Append
    }
    else
    {
        # Download winutils.exe from remote server
        Invoke-WebRequest -Uri $config.WINUTILS_URL -OutFile $winutils_file_path
        Write-TimeStampedDebugMessage "Downloaded winutils.exe from $( $config.WINUTILS_URL )" | Out-File $log_file_path -Append
    }

    # Set HADOOP_HOME environment variable
    [Environment]::SetEnvironmentVariable("HADOOP_HOME", $winutils_file_path, "User")
    Write-TimeStampedDebugMessage "Set HADOOP_HOME to $( $winutils_file_path )" | Out-File $log_file_path -Append

    # Add directory to PATH environment variable
    [Environment]::SetEnvironmentVariable("PATH", "$( $winutils_file_path ); $( $env:PATH )", "User")
    Write-TimeStampedDebugMessage "Added $( $winutils_file_path ) to PATH environment variable" | Out-File $log_file_path -Append

    # Log that the script has finished
    Write-TimeStampedDebugMessage "Finished winutils.ps1" | Out-File $log_file_path -Append

    # Log success message
    Write-Verbose "The operation completed successfully"
}
catch
{
    # Log a possible exception that could happen
    Write-Error "$( Get-Timestamp ) - ERROR: $( $_.Exception.Message )" | Out-File $log_file_path -Append
}