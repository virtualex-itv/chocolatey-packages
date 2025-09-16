$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://github.com/XhmikosR/jpegoptim-windows/releases/download/1.5.6-rel1/jpegoptim-1.5.6-rel1-win64-msvc-2022-mozjpeg331-static-ltcg.zip'
$checksum               = '07cead22ce33de657e6cadf6b84ecbac42debf80247575599db7f35a5f54a336'
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
