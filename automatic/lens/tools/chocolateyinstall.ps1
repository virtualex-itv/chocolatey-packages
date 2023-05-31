$ErrorActionPreference  = 'Stop'

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://downloads.k8slens.dev/ide/Lens%20Setup%202023.5.310801-latest.exe'
$checksum               = 'f3f729149b8d5e10c58b56c17d62c8784d4477d5dc140650eca6701e63468908'
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
