$ErrorActionPreference  = 'Stop'

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://downloads.k8slens.dev/ide/Lens%20Setup%202026.1.140649-latest.exe'
$checksum               = '4b0a3b341ae8d68ef74f9ea0b19b76fd386bb3360b3770b4f7838eb5c59c89b5'
$checksumType           = 'sha256'
$pp                     = Get-PackageParameters

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  softwareName          = 'Lens*'
  url                   = $url
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = '/allusers /disableAutoUpdates /S'
  validExitCodes        = @(0, 3010, 1605, 1614, 1641)
}

if ( $pp.CURRENTUSER) {
  $packageArgs['silentArgs'] = '/currentuser /disableAutoUpdates /S'
}

Install-ChocolateyPackage @packageArgs
