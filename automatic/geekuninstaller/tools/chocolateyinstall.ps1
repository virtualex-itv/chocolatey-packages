$ErrorActionPreference = 'Stop';

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://geekuninstaller.com/geek.zip'
$checksum              = '6fcfe76bc2d6cc175bd5f2e3ff35b3a5b50113049f1a0f8f0b0120705e723333'
$checksumType          = 'sha256'

$packageArgs = @{
  packageName          = $env:ChocolateyPackageName
  unzipLocation        = $toolsDir
  url                  = $url
  checksum             = $checksum
  checksumType         = $checksumType
}

Install-ChocolateyZipPackage @packageArgs
