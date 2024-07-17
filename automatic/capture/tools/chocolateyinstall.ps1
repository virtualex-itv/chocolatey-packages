$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://cdn.cloud.techsmith.com/techsmithcapture/win/x64/Setup.exe'
$checksum               = 'EA7ACF86CC7DD71B6BE99E20448AA4788ACC831C028EF18A6AACF8FF501239F1'
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
