$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = ''
$checksum               = ''
$checksumType           = ''

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  url                   = $url
  softwareName          = 'VMware Horizon Client*'
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = '/silent /norestart'
  validExitCodes        = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
