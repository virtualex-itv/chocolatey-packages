$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://github.com/XhmikosR/jpegoptim-windows/releases/download/1.5.3-rel1/jpegoptim-1.5.3-rel1-win64-msvc-2022-mozjpeg331-static-ltcg.zip'
$checksum               = '5ad62e7d513ba4040d32612fb378f397879dd30ec889113178c7bbea69ed3c62'
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
