$ErrorActionPreference = 'Stop'

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://packages.vmware.com/tools/releases/11.2.5/windows/x86/VMware-tools-11.2.5-17337674-i386.exe'
$checksum              = '4574457c1d8b45c29c4890b736644d49cc0fc544bcec653adefff6aadca67f7b'
$ChecksumType          = 'sha256'
$url64                 = 'https://packages.vmware.com/tools/releases/11.2.5/windows/x64/VMware-tools-11.2.5-17337674-x86_64.exe'
$checksum64            = '647af568b8a45fd79db3717186b4f7037aca2990f74e641c3f50b107829f96e3'
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
