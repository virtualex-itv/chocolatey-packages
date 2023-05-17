$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://cdn.cloud.techsmith.com/techsmithcapture/win/x64/Setup.exe'
$checksum               = 'B66B5690AD4F839F5C4AC14217B48A40CF42E9C27DC6FBE3C975356DF826F666'
$checksumType           = 'sha256'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  softwareName          = "Techsmith Capture*"
  url                   = $url
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = '--silent --acceptEULA'
  validExitCodes        = @(0)
}

Install-ChocolateyPackage @packageArgs
