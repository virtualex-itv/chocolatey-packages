$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://cdn.cloud.techsmith.com/techsmithcapture/win/x64/Setup.exe'
$checksum               = 'E84852F696917B88FB0BDC418976FECE8128F170006969963C39522B373E615F'
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
