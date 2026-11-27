$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://assets.micron.com/adobe/assets/urn:aaid:aem:cbf18087-f8b5-4434-910b-15953998aa84/renditions/original/as/storageexecutive-windows.exe'
$checksum               = '87e4a041ae3c405a2ccd5a3cbfc321fa9b46a5f6e599afe4a2d3edf61f0c5144'
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
