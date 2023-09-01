$ErrorActionPreference = 'Stop'

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://packages.vmware.com/tools/releases/12.3.0/windows/x86/VMware-tools-12.3.0-22234872-i386.exe'
$checksum              = 'ce9efa795710a25fb9b428edbf60c5ea4c5d651514a91e47c20607628f2f81f9'
$ChecksumType          = 'sha256'
$url64                 = 'https://packages.vmware.com/tools/releases/12.3.0/windows/x64/VMware-tools-12.3.0-22234872-x86_64.exe'
$checksum64            = 'ed341d23d41e1d83a2fb495c5946fb669d5db7ee078c7c85dfc995247e41f9f3'
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
