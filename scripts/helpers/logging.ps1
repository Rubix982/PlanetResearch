# Define function to return timestamp
function Get-Timestamp
{
    return "$( Get-Date -Format 'yyyy-MM-dd HH:mm:ss' )"
}

# Define function to write progess messages with timestamp
function Write-TimeStampedProgressMessage($message)
{
    Write-Progress -Activity "winutils.ps1" -Status $message
}

# Define function to write warning messages with timestamp
function Write-TimeStampedWarningMessage($message)
{
    Write-Warning "$( Get-Timestamp ) - $message"
}

# Define function to write error messages with timestamp
function Write-TimeStampedErrorMessage($message)
{
    Write-Error "$( Get-Timestamp ) - $message"
}

# Define function to write debug messages with timestamp
function Write-TimeStampedDebugMessage($message)
{
    Write-Debug "$( Get-Timestamp ) - $message"
}

Export-ModuleMember -Function Get-Timestamp, Write-TimeStampedProgressMessage, Write-TimeStampedWarningMessage, Write-TimeStampedErrorMessage, Write-TimeStampedDebugMessage
