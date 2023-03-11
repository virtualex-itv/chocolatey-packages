$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://github.com/XhmikosR/jpegoptim-windows/releases/download/1.5.2-rel1/jpegoptim-1.5.2-rel1-win64-msvc-2022-mozjpeg331-static-ltcg.zip'
$checksum               = 'eda61db49d240937f9089e277fea9f77868fb8916bf8fea771f110e4f35c2738'
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
