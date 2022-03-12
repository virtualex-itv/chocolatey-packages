$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://media-www.micron.com/-/media/client/global/documents/products/software/storage-executive-software/storageexecutive_windows.exe?rev=8774a41b86104c358a762f17de8d246c'
$checksum               = '9b31c9134cc1b785efc8b9714c3a7184f73d0941b872067c1b5c3c5ad2955b66'
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
