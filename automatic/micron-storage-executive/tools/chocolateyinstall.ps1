$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://media-www.micron.com/-/media/client/global/documents/products/software/storage-executive-software/storageexecutive_windows.exe?rev=7e2dfa552e62440ea73e911e0c3e34ab'
$checksum               = '0ca68e3ff4654cd6ee7717c63264a38ff5c06a32dec11c01c000ca0f54fa7de0'
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
