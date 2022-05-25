$ErrorActionPreference = 'Stop'

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://packages.vmware.com/tools/releases/12.0.5/windows/x86/VMware-tools-12.0.5-19716617-i386.exe'
$checksum              = '293fb7821f106e54e01227e32ce60e80205bcde53641fff817902afa377c6307'
$ChecksumType          = 'sha256'
$url64                 = 'https://packages.vmware.com/tools/releases/12.0.5/windows/x64/VMware-tools-12.0.5-19716617-x86_64.exe'
$checksum64            = 'e4de7a7eda1ab6c0946f556a5a47f62fb2d6a97031e4e07fa82896096aa31d2e'
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
