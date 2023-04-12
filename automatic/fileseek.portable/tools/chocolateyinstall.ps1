$ErrorActionPreference = 'Stop';

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://binaryfortressdownloads.com/Download/BFSFiles/103/FileSeek-6.8-x64.zip'
$checksum              = '9568609a45084a52285d75265396758d0d0425e2bfaa0edbd246538a303ba3df'
$checksumType          = 'sha256'

$packageArgs = @{
  packageName          = $env:ChocolateyPackageName
  unzipLocation        = $toolsDir
  url                  = $url
  checksum             = $checksum
  checksumType         = $checksumType
}

Install-ChocolateyZipPackage @packageArgs
