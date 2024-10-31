$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://resources.robware.net/resources/prod/RVTools4.7.1.msi'
$checksum               = '0506126bcbc4641d41c138e88d9ea9f10fb65f1eeab3bff90ad25330108b324c'
$checksumType           = 'sha256'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'msi'
  softwareName          = 'RVTools*'
  url                   = $url
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = "/qn REBOOT=ReallySuppress"
  validExitCodes        = @(0)
}

$isInstalled = Get-CimInstance -ClassName Win32_Product | Where-Object { $_.Name -like "*$env:ChocolateyPackageName*" }

if ($isInstalled) {
  Write-Host "`n$env:ChocolateyPackageName installation found, uninstalling prior to upgrade...`n" -ForegroundColor Yellow
  $isInstalled | Invoke-CimMethod -MethodName Uninstall | Out-Null
}

Install-ChocolateyPackage @packageArgs
