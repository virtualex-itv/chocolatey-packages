$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://assets.micron.com/adobe/assets/urn:aaid:aem:cbf18087-f8b5-4434-910b-15953998aa84/renditions/original/as/storageexecutive-windows.exe'
$checksum               = 'b425edb506aca0b074b3965920a8043b0f680b27dfea524c3e0be4b7722135d4'
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
