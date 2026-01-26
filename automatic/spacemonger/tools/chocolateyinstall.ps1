$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://cdn.stardock.us/downloads/public/software/spacemonger/SpaceMonger_sd_setup.exe'
$checksum               = '51a4478774ef998baf8f54245ab3dd00a8ab1e2e7f8b7e334fe57a640a482f68'
$checksumType           = 'sha256'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  softwareName          = "EdgeRunner SpaceMonger*"
  url                   = $url
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = '/s'
  validExitCodes        = @(0)
}

Install-ChocolateyPackage @packageArgs
