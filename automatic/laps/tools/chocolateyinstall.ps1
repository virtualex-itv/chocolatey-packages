$ErrorActionPreference = 'Stop'

$toolsDir            = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                 = 'https://download.microsoft.com/download/C/7/A/C7AAD914-A8A6-4904-88A1-29E657445D03/LAPS.x86.msi'
$checksum            = '9f0fa541b472c20508973f561b0d7850a7bf779c8459f9e33471083619fd6eda'
$checksumType        = 'sha256'
$url64               = 'https://download.microsoft.com/download/C/7/A/C7AAD914-A8A6-4904-88A1-29E657445D03/LAPS.x64.msi'
$checksum64          = 'f63ebbc45e2d080630bd62a195cd225de734131a56bb7b453c84336e37abd766'
$checksumType64      = 'sha256'
$pp                  = Get-PackageParameters

if ( $pp.ALL ) {
  Write-Host "`nInstalling Microsoft Local Account Password Solution with Management Tools...`n" -ForegroundColor Yellow

  $packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'msi'
    softwareName   = "Local Account Password Solution*"
    url            = $url
    url64bit       = $url64
    validExitCodes = @(0, 3010)
    silentArgs     = 'ADDLOCAL=ALL /qn /norestart'
    checksum       = $checksum
    checksumType   = $checksumType
    checksum64     = $checksum64
    checksumType64 = $checksumType64
  }

  Install-ChocolateyPackage @packageArgs
} else {
  Write-Host "`nInstalling Microsoft Local Account Password Solution...`n" -ForegroundColor Yellow

  $packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'msi'
    softwareName   = "Local Account Password Solution*"
    url            = $url
    url64bit       = $url64
    validExitCodes = @(0, 3010)
    silentArgs     = '/qn /norestart'
    checksum       = $checksum
    checksumType   = $checksumType
    checksum64     = $checksum64
    checksumType64 = $checksumType64
  }

  Install-ChocolateyPackage @packageArgs
}
