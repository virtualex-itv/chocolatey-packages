$ErrorActionPreference = 'Stop'

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://packages.vmware.com/tools/releases/12.1.0/windows/x86/VMware-tools-12.1.0-20219665-i386.exe'
$checksum              = '0aaf4e0a63323706cf28857b7419a8328836cb2dd5828d00e4be9d38d132cf0b'
$ChecksumType          = 'sha256'
$url64                 = 'https://packages.vmware.com/tools/releases/12.1.0/windows/x64/VMware-tools-12.1.0-20219665-x86_64.exe'
$checksum64            = '520a0ab010311d09e37ef5a461fb42565f8415792fd8c026aa9264d3359129ce'
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
