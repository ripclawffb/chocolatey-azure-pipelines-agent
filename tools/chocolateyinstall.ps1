$ErrorActionPreference = 'Stop';

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$installDir = "C:\Agent"

Set-Content -Path "$toolsDir\installDir.txt" -Value $installDir

$additionalArgs = ''
$packageParameters = Get-PackageParameters

if ($packageParameters['url']) { $agent_url = $packageParameters['url'] }
if ($packageParameters['auth']) { $auth = $packageParameters['auth'] }
if ($packageParameters['token']) { $token = $packageParameters['token'] }
if ($packageParameters['userName']) { $userName = $packageParameters['userName'] }
if ($packageParameters['password']) { $password = $packageParameters['password'] }

if ($packageParameters['pool']) { $pool = $packageParameters['pool'] }
if ($packageParameters['agent']) { $agent = $packageParameters['agent'] }
if ($packageParameters['replace']) { $replace = $true }

if ($packageParameters['work']) { $work = $packageParameters['work'] }
if ($packageParameters['disableloguploads']) { $disableloguploads = $true }

if ($packageParameters['runAsService']) { $runAsService = $true }
if ($packageParameters['runAsAutoLogon']) { $runAsAutoLogon = $true }
if ($packageParameters['windowsLogonAccount']) { $windowsLogonAccount = $packageParameters['windowsLogonAccount'] }
if ($packageParameters['windowsLogonPassword']) { $windowsLogonPassword = $packageParameters['windowsLogonPassword'] }
if ($packageParameters['noRestart']) { $noRestart  = $packageParameters['noRestart'] }

if ($packageParameters['deploymentGroup']) { $deploymentGroup = $true }
if ($packageParameters['deploymentGroupName']) { $deploymentGroupName = $packageParameters['deploymentGroupName'] }
if ($packageParameters['projectName']) { $projectName = $packageParameters['projectName'] }
if ($packageParameters['addDeploymentGroupTags']) { $addDeploymentGroupTags = $true }
if ($packageParameters['deploymentGroupTags']) { $deploymentGroupTags  = $packageParameters['deploymentGroupTags'] }

if(Get-Variable -Name agent_url -ErrorAction SilentlyContinue) {
  $additionalArgs = "--url $agent_url"
}

if(Get-Variable -Name auth -ErrorAction SilentlyContinue) {
  if($auth -eq 'pat') {
    $additionalArgs += " --auth pat --token $token"
  }

  if($auth -eq 'negotiate') {
    $additionalArgs += " --auth negotiate --userName $userName --password $password"
  }

  if($auth -eq 'alt') {
    $additionalArgs += " --auth alt --userName $userName --password $password"
  }

  if($auth -eq 'integrated') {
    $additionalArgs += " --auth integrated"
  }
}

if(Get-Variable -Name pool -ErrorAction SilentlyContinue) {
  $additionalArgs += " --pool $pool"
}

if(Get-Variable -Name agent -ErrorAction SilentlyContinue) {
  $additionalArgs += " --agent $agent"
}

if(Get-Variable -Name replace -ErrorAction SilentlyContinue) {
  $additionalArgs += " --replace"
}

if(Get-Variable -Name work -ErrorAction SilentlyContinue) {
  $additionalArgs += " --work $work"
}

if(Get-Variable -Name disableloguploads  -ErrorAction SilentlyContinue) {
  $additionalArgs += " --disableloguploads"
}

if(Get-Variable -Name runAsService -ErrorAction SilentlyContinue) {
  $additionalArgs += " --runAsService"
  if(Get-Variable -Name windowsLogonAccount -ErrorAction SilentlyContinue) {
    $additionalArgs += " --windowsLogonAccount $windowsLogonAccount --windowsLogonPassword $windowsLogonPassword"
  }
}

if(Get-Variable -Name runAsAutoLogon -ErrorAction SilentlyContinue) {
  $additionalArgs += " --runAsAutoLogon --windowsLogonAccount $windowsLogonAccount --windowsLogonPassword $windowsLogonPassword"

  if(Get-Variable -Name overwriteAutoLogon -ErrorAction SilentlyContinue) {
    $additionalArgs += " --overwriteAutoLogon"
  }

  if(Get-Variable -Name noRestart -ErrorAction SilentlyContinue) {
    $additionalArgs += " --noRestart"
  }
}

if(Get-Variable -Name deploymentGroup -ErrorAction SilentlyContinue) {
  $additionalArgs += " --deploymentGroup ----deploymentGroupName $deploymentGroupName --projectName $projectName"

  if(Get-Variable -Name addDeploymentGroupTags -ErrorAction SilentlyContinue) {
    $additionalArgs += " --addDeploymentGroupTags --deploymentGroupTags $deploymentGroupTags"
  }
}

$url        = 'https://vstsagentpackage.azureedge.net/agent/2.173.0/vsts-agent-win-x86-2.173.0.zip'
$url64      = 'https://vstsagentpackage.azureedge.net/agent/2.173.0/vsts-agent-win-x64-2.173.0.zip'

If (Get-OSArchitectureWidth -Compare 32) {
  $zipFileName        = $url.Split('/')[-1]
} Else {
  $zipFileName      = $url64.Split('/')[-1]
}

Set-Content -Path "$toolsDir\zipFilename.txt" -Value $zipFileName

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $installDir
  url           = $url
  url64bit      = $url64

  checksum      = '144c3f0196acbda02d21d8524c165d09637371499df949a8609370ef4245c52d'
  checksumType  = 'sha256'
  checksum64    = '1cdddf4fa32757322631c8db55c89172b5f2672b46cc828d8dbb1024fd27ca8b'
  checksumType64= 'sha256'

}

Install-ChocolateyZipPackage @packageArgs

Start-Process -NoNewWindow -FilePath "$installDir\config.cmd" -ArgumentList "--unattended --acceptTeeEula $additionalArgs"
