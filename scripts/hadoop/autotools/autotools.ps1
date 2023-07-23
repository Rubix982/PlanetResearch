# Import
Import-Module -Name (Join-Path (Get-Location).Path "\scripts\helpers\logging.psm1") -Force

Write-TimeStampedDebugMessage "Starting autotools.ps1..."

Write-TimeStampedDebugMessage "Checking if Chocolatey is installed..."

if (!(Get-Command choco -ErrorAction SilentlyContinue))
{
    Write-TimeStampedErrorMessage "Chocolatey is not installed. Please install Chocolatey and try again."
    exit 1
}

Write-TimeStampedDebugMessage "Installing GNU tools..."

$packages = "autoconf", "automake", "libtool"

Write-TimeStampedDebugMessage "Packages to install: $packages"

foreach ($package in $packages)
{
    Write-TimeStampedDebugMessage "Checking if $package is already installed..."

    if (!(Get-Command $package -ErrorAction SilentlyContinue))
    {
        Write-TimeStampedDebugMessage "$package is not installed. Installing $package..."
        choco install $package -y
    }
    else
    {
        Write-TimeStampedDebugMessage "$package is already installed."
    }
}