$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://github.com/XhmikosR/jpegoptim-windows/releases/download/1.5.5-rel1/jpegoptim-1.5.5-rel1-win64-msvc-2022-mozjpeg331-static-ltcg.zip'
$checksum               = 'd1bd9c86f82f806b9301b0433e8c9a17d5d7f1eed72868407eb975d7e07800a5'
$checksumType           = 'sha256'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  softwareName          = "jpegoptim*"
  url                   = $url
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = '/s'
  validExitCodes        = @(0)
}

Install-ChocolateyZipPackage @packageArgs
