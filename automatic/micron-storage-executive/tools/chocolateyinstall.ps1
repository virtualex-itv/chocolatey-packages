$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://media-www.micron.com/-/media/client/global/documents/products/software/storage-executive-software/storageexecutive_windows.exe?rev=e47771bea2c747df8dbac7d3972dfc0a'
$checksum               = '463c3cfef20ce316ff2a08a1a93010233258ecd7af363e6431c305d3e2643227'
$checksumType           = 'sha256'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  softwareName          = "Micron Storage Executive*"
  url                   = $url
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = '--mode unattended'
  validExitCodes        = @(0)
}

Install-ChocolateyPackage @packageArgs
