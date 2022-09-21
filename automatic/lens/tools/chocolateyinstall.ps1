$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://downloads.k8slens.dev/ide/Lens%20Setup%202022.9.211442-latest.exe'
$checksum               = 'bf2f536d6ee589deb97ed4f4cd72edcb815f2b1fec9740c808435310a1860ae9'
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
