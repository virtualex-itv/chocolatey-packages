$ErrorActionPreference = 'Stop'

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://packages.vmware.com/tools/releases/12.1.5/windows/x86/VMware-tools-12.1.5-20735119-i386.exe'
$checksum              = '6e20d2f5a56edf48ca9a3c46508cf640482dba138f5833496f0bb402610cf887'
$ChecksumType          = 'sha256'
$url64                 = 'https://packages.vmware.com/tools/releases/12.1.5/windows/x64/VMware-tools-12.1.5-20735119-x86_64.exe'
$checksum64            = '2c1d6ef7ae17e57a5ae48d38951b1fe2f2f1eb7c7cdd05e3ab785c78b562e958'
$ChecksumType64        = 'sha256'

$pp                    = Get-PackageParameters

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

if ( $pp.ALL ) {
  Write-Host "`nPerforming a Complete installation of VMware Tools...`n" -ForegroundColor Yellow

  $packageArgs['silentArgs'] = '/S /v /qn REBOOT=R ADDLOCAL=ALL'

} else {
  Write-Host "`nPerforming a Typical installation of VMware Tools...`n" -ForegroundColor Yellow
}

Install-ChocolateyPackage @packageArgs
