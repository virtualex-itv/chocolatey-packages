$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://downloads.k8slens.dev/ide/Lens%20Setup%206.0.2-latest.20220908.1.exe'
$checksum               = 'a33c33fe8a52e2a0d9fa4f24e9085a471047a599ab325d8519c3863bb73ddc7c'
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
