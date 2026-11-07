$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://github.com/XhmikosR/jpegoptim-windows/releases/download/1.5.6-rel2/jpegoptim-1.5.6-rel2-win64-msvc-2026-mozjpeg415-static-ltcg.zip'
$checksum               = '112162e40351b604ba6f1e5eb0520a49c6255c0177b8a1cb8a6b80820ca8acc4'
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
