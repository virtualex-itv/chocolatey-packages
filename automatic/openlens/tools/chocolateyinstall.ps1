$ErrorActionPreference  = 'Stop'

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://github.com/MuhammedKalkan/OpenLens/releases/download/v6.4.0-beta.15/OpenLens-6.4.0-beta.15.exe'
$checksum               = 'b63bbbf7e86b8ebfaadb78cd15bc3e11974b8d04844491bfc99dbc93e14908c8'
$checksumType           = 'sha256'
$pp                     = Get-PackageParameters

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  softwareName          = 'OpenLens*'
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
