$ErrorActionPreference = 'Stop'

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://packages.vmware.com/tools/releases/10.3.10/windows/x86/VMware-tools-10.3.10-12406962-i386.exe'
$checksum              = '59a498cc1641a04c10d08709ac6dc6aa95cafc7b56e6d613d3630e89083f0f4c'
$ChecksumType          = 'sha256'
$url64                 = 'https://packages.vmware.com/tools/releases/10.3.10/windows/x64/VMware-tools-10.3.10-12406962-x86_64.exe'
$checksum64            = '65d5cc22d2fae73f104e985baa7885a1544adceb0774cc302522c03541e5dd82'
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
