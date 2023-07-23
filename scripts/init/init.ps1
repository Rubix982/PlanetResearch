# Setup spark
& (Join-Path (Get-Location).Path "\scripts\spark\setup_spark_config.ps1") -Debug

# Setup hadoop tooling
& (Join-Path (Get-Location).Path "\scripts\hadoop\setup_hadoop_config.ps1") -Debug