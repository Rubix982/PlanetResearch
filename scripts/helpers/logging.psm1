# Writing to console configurations
$ErrorActionPreference = "Continue"
$WarningPreference = "Continue"
$DebugPreference = "Continue"
$VerbosePreference = "Continue"

# Logging configurations
$LOG_DIR = "logs"
$LOG_PATHS = @{ }

# Define function to write to log file
function Write-Log($message)
{
    $message | Out-File -FilePath $obtained_log_file_path -Append
}

# Define function to return timestamp
function Get-Timestamp
{
    return "$( Get-Date -Format 'yyyy-MM-dd HH:mm:ss' )"
}

# Define function to write progess messages with timestamp
function Write-TimeStampedProgressMessage($message)
{
    $formatted_message = "$( Get-Timestamp ) - [PROGRESS]:: $message"
    Write-Progress -Activity "winutils.ps1" -Status $formatted_message
    Write-Log $formatted_message
}

# Define function to write warning messages with timestamp
function Write-TimeStampedWarningMessage($message)
{
    $formatted_message = "$( Get-Timestamp ) - [WARNING]:: $message"
    Write-Warning $formatted_message
    Write-Log $formatted_message
}

# Define function to write error messages with timestamp
function Write-TimeStampedErrorMessage($message)
{
    $formatted_message = "$( Get-Timestamp ) - [ERROR]:: $message"
    Write-Error $formatted_message
    Write-Log $formatted_message
}

# Define function to write debug messages with timestamp
function Write-TimeStampedDebugMessage($message)
{
    $formatted_message = "$( Get-Timestamp ) - [DEBUG]:: $message"
    Write-Debug $formatted_message
    Write-Log $formatted_message
}

# Define an enum for log message types
enum LogMessageType
{
    Progress
    Warning
    Error
    Debug
}

# Define function to write progress messages with timestamp
function LogMessageTypePaths
{
    foreach ($log_path in $LOG_PATHS.keys)
    {
        if ($LOG_PATHS[$log_path] -eq [LogMessageType]::Progress)
        {
            Write-Progress -Activity $log_path
        }
        elseif ($LOG_PATHS[$log_path] -eq [LogMessageType]::Warning)
        {
            Write-TimeStampedWarningMessage $log_path
        }
        elseif ($LOG_PATHS[$log_path] -eq [LogMessageType]::Error)
        {
            Write-TimeStampedErrorMessage $log_path
        }
        elseif ($LOG_PATHS[$log_path] -eq [LogMessageType]::Debug)
        {
            Write-TimeStampedDebugMessage $log_path
        }
    }
}

function Get-LogFilePath
{
    # Specify script path
    $script_path = (Join-Path (Get-Location).Path "scripts")
    $LOG_PATHS["Script path: $script_path"] = [LogMessageType]::Debug

    # Construct path to log file
    $log_dir_path = Join-Path $script_path $LOG_DIR
    $LOG_PATHS["Log directory path: $log_dir_path"] = [LogMessageType]::Debug

    # Create log directory if it doesn't exist
    if (-not(Test-Path $log_dir_path))
    {
        $LOG_PATHS["Log directory does not exist"] = [LogMessageType]::Warning
        $LOG_PATHS["Creating log directory"] = [LogMessageType]::Debug
        New-Item -ItemType Directory -Path $log_dir_path
        $LOG_PATHS["Log directory created successfully"] = [LogMessageType]::Progress
    }

    # Build log file name
    $log_file_name = "$((Get-Timestamp).Replace(' ', '_').Replace(':', '-') )_hadoop.log"
    $LOG_PATHS["Log file name: $log_file_name"] = [LogMessageType]::Debug

    # Construct path to log file
    $log_file_path = Join-Path $log_dir_path $log_file_name
    $LOG_PATHS["Log file path: $log_file_path"] = [LogMessageType]::Debug

    return $log_file_path
}

# Define function to write to log file
$obtained_log_file_path = Get-LogFilePath

LogMessageTypePaths

Export-ModuleMember -Function Get-Timestamp, Write-TimeStampedProgressMessage, Write-TimeStampedWarningMessage, Write-TimeStampedErrorMessage, Write-TimeStampedDebugMessage
