$SparkUrl = "https://dlcdn.apache.org/spark/spark-3.4.1/spark-3.4.1-bin-hadoop3.tgz"
$ScriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path

try
{
    # Download Spark
    Write-Host "Downloading Spark..."

    Invoke-WebRequest -Uri $SparkUrl -OutFile $ScriptDirectory

    # Extract Spark
    Write-Host "Extracting Spark..."
    Expand-Archive -Path $ScriptDirectory -DestinationPath $ScriptDirectory -Force

    # Verify integrity using certUtil
    Write-Host "Verifying integrity..."

    certUtil -hashfile $ScriptDirectory SHA256 | Select-String -Pattern "HASH_VALUE"

    Write-Host "Spark setup completed successfully."
}
catch
{
    Write-Host "Error: $( $_.Exception.Message )"
}