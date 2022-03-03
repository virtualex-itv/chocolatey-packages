$ErrorActionPreference = 'Stop'

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://packages.vmware.com/tools/releases/12.0.0/windows/x86/VMware-tools-12.0.0-19345655-i386.exe'
$checksum              = 'e9387e3c3d640ff440972b5d9cced3671dbad6507be477ab7d2069c837a45c54'
$ChecksumType          = 'sha256'
$url64                 = 'https://packages.vmware.com/tools/releases/12.0.0/windows/x64/VMware-tools-12.0.0-19345655-x86_64.exe'
$checksum64            = 'a2c43144ce0a0dac450319fa5b01211aa2e0de8efe0f132a7cd02d8c07fa4473'
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
