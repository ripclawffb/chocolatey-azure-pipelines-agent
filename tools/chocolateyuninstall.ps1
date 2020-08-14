$ErrorActionPreference = 'Stop';

$toolsDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$zipFileName = Get-Content -Path "$toolsDir\zipFilename.txt"

$packageName   = $env:ChocolateyPackageName

# Stop AutoLogon Agent if running
Get-Process | Where-Object {$_.MainWindowTitle -like "*Agent with AutoLogon*"} | Stop-Process -Force

Uninstall-ChocolateyZipPackage $packageName -zipFileName $zipFileName
