$ErrorActionPreference = 'Stop';

$toolsDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$zipFileName = Get-Content -Path "$toolsDir\zipFilename.txt"

$packageName   = $env:ChocolateyPackageName

Uninstall-ChocolateyZipPackage $packageName -zipFileName $zipFileName
