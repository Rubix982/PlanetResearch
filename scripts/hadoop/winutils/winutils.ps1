# Configurations
$DebugPreference = "Continue"
$VerbosePreference = "Continue"

Import-Module -Name (Join-Path (Get-Location).Path "\scripts\helpers\logging.psm1") -Force

# Greet user
Write-TimeStampedDebugMessage "Starting winutils.ps1"

# Specify script path
$script_path = (Join-Path (Get-Location).Path "scripts")
Write-TimeStampedDebugMessage "Script path: $script_path"

# Bin directory path
$bin_dir_path = (Join-Path (Get-Location).Path "bin")
Write-TimeStampedDebugMessage "Bin directory path: $bin_dir_path"

# Create bin directory if it doesn't exist
if (-not(Test-Path $bin_dir_path))
{
    Write-TimeStampedWarningMessage "Bin directory does not exist"
    Write-TimeStampedDebugMessage "Creating bin directory"
    New-Item -ItemType Directory -Path $bin_dir_path
    Write-TimeStampedProgressMessage "Bin directory created successfully"
}

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
    Write-TimeStampedErrorMessage "ERROR: config.txt file not found"
    exit 1
}

# Read the WINUTILS_URL value from config.txt
$config = Get-Content $config_file_path  | ConvertFrom-StringData
Write-TimeStampedDebugMessage "Config file loaded successfully"

# Winutils file path
$winutils_file_path = (Join-Path $bin_dir_path $config.FILE_NAME)
Write-TimeStampedDebugMessage "Winutils file path: $winutils_file_path"

try
{
    Write-TimeStampedDebugMessage "Checking if winutils.exe exists previously"

    # Check if the file already exists locally
    if (Test-Path $winutils_file_path)
    {
        # If it is, then log that it is, and move on
        Write-TimeStampedDebugMessage "winutils.exe already exists locally"
    }
    else
    {
        # Download winutils.exe from remote server
        Invoke-WebRequest -Uri $config.WINUTILS_URL -OutFile $winutils_file_path
        Write-TimeStampedDebugMessage "Downloaded winutils.exe from $( $config.WINUTILS_URL )"
    }

    $envVariables = @(
    "HADOOP_HOME",
    "HADOOP_HOME_DIR"
    )

    foreach ($envVariable in $envVariables)
    {
        # Delete environment variable if it exists
        Write-TimeStampedDebugMessage "Checking if $envVariable exists previously"

        if ( [Environment]::GetEnvironmentVariable($envVariable, "User"))
        {
            Write-TimeStampedDebugMessage "Deleting $envVariable"
            [Environment]::SetEnvironmentVariable($envVariable, $null, "User")
        }

        # Set environment variable
        [Environment]::SetEnvironmentVariable($envVariable, $bin_dir_path, "User")
        Write-TimeStampedDebugMessage "Set $envVariable to $( $bin_dir_path )"
    }

    # Add directory to PATH environment variable
    [Environment]::SetEnvironmentVariable("PATH", "$( $winutils_file_path ); $( $env:PATH )", "User")
    Write-TimeStampedDebugMessage "Added $( $winutils_file_path ) to PATH environment variable"

    # Log that the script has finished
    Write-TimeStampedDebugMessage "Finished winutils.ps1"

    # Log success message
    Write-Verbose "The operation completed successfully"
}
catch
{
    # Log a possible exception that could happen
    Write-TimeStampedErrorMessage "ERROR: $( $_.Exception.Message )"
}