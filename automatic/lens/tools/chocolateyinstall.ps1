$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://downloads.k8slens.dev/ide/Lens%20Setup%202022.9.201328-latest.exe'
$checksum               = 'd0e2b88c41299125c1a750b5ec3cf2dca6970b3101b8a13ec7f72f76a2581f1f'
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
  silentArgs            = '/currentuser /disableAutoUpdates /S'
  validExitCodes        = @(0, 3010, 1605, 1614, 1641)
}

if ( $pp.ALLUSERS) {
  $packageArgs['silentArgs'] = '/allusers /disableAutoUpdates /S'
}

Install-ChocolateyPackage @packageArgs
