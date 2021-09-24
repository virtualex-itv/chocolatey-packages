$ErrorActionPreference = 'Stop'

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://packages.vmware.com/tools/releases/11.3.5/windows/x86/VMware-tools-11.3.5-18557794-i386.exe'
$checksum              = '0850a4944be281c2001b1d711eb9872771c379de775e0ac152613627a93da4be'
$ChecksumType          = 'sha256'
$url64                 = 'https://packages.vmware.com/tools/releases/11.3.5/windows/x64/VMware-tools-11.3.5-18557794-x86_64.exe'
$checksum64            = '22bf2f91e78e13e4964ae3d2c52db8c341e21518aa78996696474b1dd905e8ca'
$ChecksumType64        = 'sha256'

$pp                    = Get-PackageParameters

if ( $pp.ALL ) {
  Write-Host "`nPerforming a Complete installation of VMware Tools...`n" -ForegroundColor Yellow

  $packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = $url
    url64bit       = $url64
    validExitCodes = @(0, 3010)
    silentArgs     = '/S /v /qn REBOOT=R ADDLOCAL=ALL'
    softwareName   = "VMware Tools*"
    checksum       = $checksum
    checksumType   = $ChecksumType
    checksum64     = $checksum64
    checksumType64 = $ChecksumType64
  }

  Install-ChocolateyPackage @packageArgs
} else {
  Write-Host "`nPerforming a Typical installation of VMware Tools...`n" -ForegroundColor Yellow

  $packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = $url
    url64bit       = $url64
    validExitCodes = @(0, 3010)
    silentArgs     = '/S /v /qn REBOOT=R'
    softwareName   = "VMware Tools*"
    checksum       = $checksum
    checksumType   = $ChecksumType
    checksum64     = $checksum64
    checksumType64 = $ChecksumType64
  }

  Install-ChocolateyPackage @packageArgs
}
