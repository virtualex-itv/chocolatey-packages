$ErrorActionPreference = 'Stop'

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://packages.vmware.com/tools/releases/12.2.6/windows/x86/VMware-tools-12.2.6-22229486-i386.exe'
$checksum              = '330cf3bc1d1bb192e90f4023852549f4ae7bb9e2b6777f6a42849f9b84cc40ab'
$ChecksumType          = 'sha256'
$url64                 = 'https://packages.vmware.com/tools/releases/12.2.6/windows/x64/VMware-tools-12.2.6-22229486-x86_64.exe'
$checksum64            = 'c63aaaf8a0e6047376d62004b8ceffaf4dcc4fbdf59c48eb86fc6e066ed3b1f8'
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
