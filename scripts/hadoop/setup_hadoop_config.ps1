# Download winutils.exe from remote server
& (Join-Path (Get-Location).Path "\scripts\hadoop\winutils\winutils.ps1") -Debug

# Native Hadoop Library Pipeline (https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/NativeLibraries.html#Download)

## C compiler setup (using TCC)
### & powershell.exe -ExecutionPolicy Bypass -File (Join-Path (Get-Location).Path "\scripts\hadoop\native\native.ps1") -Debug
