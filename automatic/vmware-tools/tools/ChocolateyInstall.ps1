﻿$ErrorActionPreference = 'Stop'

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

#$url                   = 'https://packages.vmware.com/tools/releases/12.4.5/windows/x86/VMware-tools-12.4.5-23787635-i386.exe'
#$checksum              = '5229bbf3d3c8bf4a84e04eb8a2cfc675d48257034e17346e21af218fb7285c19'
#$ChecksumType          = 'sha256'
$url64                 = 'https://packages.vmware.com/tools/releases/12.5.0/windows/x64/VMware-tools-12.5.0-24276846-x64.exe'
$checksum64            = '33b2fd3587fe43d59d12b6c6f94e7cdf2d143a76921a2618f910768d5e7bcab2'
$ChecksumType64        = 'sha256'

$pp                    = Get-PackageParameters

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'exe'
  #url            = $url
  url64bit       = $url64
  validExitCodes = @(0, 3010)
  silentArgs     = '/S /v /qn REBOOT=R'
  softwareName   = "VMware Tools*"
  #checksum       = $checksum
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
