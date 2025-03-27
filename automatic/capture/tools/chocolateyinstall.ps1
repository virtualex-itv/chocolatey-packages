$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://cdn.cloud.techsmith.com/techsmithcapture/win/x64/Setup.exe'
$checksum               = 'B35D4910741056B6866BD251E16E42B2DAA6D13A1FD50466BCA1E4AD0C9B6559'
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
