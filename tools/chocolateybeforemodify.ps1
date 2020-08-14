# This runs in 0.9.10+ before upgrade and uninstall.
# Use this file to do things like stop services prior to upgrade or uninstall.
# NOTE: It is an anti-pattern to call chocolateyUninstall.ps1 from here. If you
#  need to uninstall an MSI prior to upgrade, put the functionality in this
#  file without calling the uninstall script. Make it idempotent in the
#  uninstall script so that it doesn't fail when it is already uninstalled.
# NOTE: For upgrades - like the uninstall script, this script always runs from 
#  the currently installed version, not from the new upgraded package version.

$toolsDir    = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$installDir  = Get-Content -Path "$toolsDir\installDir.txt"

# Stop and remove Agent service if installed
If (Get-Service vstsagent* -ErrorAction SilentlyContinue) {
    Get-Service vstsagent* | Stop-Service -Force
    $serviceName = Get-Service vstsagent* | Select-Object -ExpandProperty Name
    Get-CimInstance -ClassName Win32_Service -Filter "Name=`"$serviceName`"" | Remove-CimInstance
}

# Stop AutoLogon Agent if running
Get-Process | Where-Object {$_.MainWindowTitle -like "*Agent with AutoLogon*"} | Stop-Process -Force

Remove-Item -Path "$installDir\.agent" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$installDir\.autologon" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$installDir\.credentials" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$installDir\.credentials_rsaparams" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$installDir\.service" -Force -ErrorAction SilentlyContinue
