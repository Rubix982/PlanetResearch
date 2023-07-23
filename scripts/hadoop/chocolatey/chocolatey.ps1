# Imports
Import-Module -Name (Join-Path (Get-Location).Path "\scripts\helpers\logging.psm1") -Force

function Install-Chocolatey
{
    Write-TimeStampedDebugMessage "Checking if Chocolatey is already installed"

    if (!(Get-Command choco -ErrorAction SilentlyContinue))
    {
        Write-TimeStampedDebugMessage "Chocolatey is not installed. Installing Chocolatey..."

        # Set execution policy for script installation
        Write-TimeStampedDebugMessage "Setting execution policy for script installation"
        Set-ExecutionPolicy Bypass -Scope Process -Force

        # Install Chocolatey
        Write-TimeStampedDebugMessage "Installing Chocolatey"

        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

        Write-TimeStampedProgressMessage "Chocolatey installed successfully"
    }
    else
    {
        Write-TimeStampedDebugMessage "Chocolatey is already installed."
    }
}

Write-TimeStampedDebugMessage "Starting chocolatey.ps1"
Install-Chocolatey
