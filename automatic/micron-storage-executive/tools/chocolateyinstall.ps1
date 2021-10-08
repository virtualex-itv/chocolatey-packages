$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://media-www.micron.com/-/media/client/global/documents/products/software/storage-executive-software/storageexecutive_windows.exe?rev=67deac48e3864191a1442f1c825f2219'
$checksum               = 'b41be87256faf0290bdbfedbfd104e2e7244e24f6fa60bede37e03c055e4f4bd'
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
