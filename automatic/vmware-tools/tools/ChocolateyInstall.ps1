$ErrorActionPreference = 'Stop'

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://packages.vmware.com/tools/releases/11.3.0/windows/x86/VMware-tools-11.3.0-18090558-i386.exe'
$checksum              = 'a8de439939aff185a0f5b2ff8682e0002b9c70a2409490643715425f5af653b2'
$ChecksumType          = 'sha256'
$url64                 = 'https://packages.vmware.com/tools/releases/11.3.0/windows/x64/VMware-tools-11.3.0-18090558-x86_64.exe'
$checksum64            = 'e89dabd07d27cbbb70d8370ed1cdcf527c59663f7a69514f4ff164055270f184'
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
