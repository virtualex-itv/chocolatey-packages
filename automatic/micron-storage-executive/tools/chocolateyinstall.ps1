$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://media-www.micron.com/-/media/client/global/documents/products/software/storage-executive-software/storageexecutive_windows.exe?rev=f55e29c67be647829887d891e566d732'
$checksum               = 'b9ece3a0f7495ab2228b010f33571f552c05a0cf1beb7d0d1bc02b49c1f9dc4e'
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
