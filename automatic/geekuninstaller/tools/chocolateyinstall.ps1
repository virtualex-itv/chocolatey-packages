$ErrorActionPreference = 'Stop';

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://geekuninstaller.com/geek.zip'
$checksum              = '2c84c3145f9b4ae6f1e0099536902754f5b79001557a9f345bc69eb72080f61c'
$checksumType          = 'sha256'

$packageArgs = @{
  packageName          = $env:ChocolateyPackageName
  unzipLocation        = $toolsDir
  url                  = $url
  checksum             = $checksum
  checksumType         = $checksumType
}

Install-ChocolateyZipPackage @packageArgs
