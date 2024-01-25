$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://cdn.cloud.techsmith.com/techsmithcapture/win/x64/Setup.exe'
$checksum               = '006CEAEA8820C4E98ED6EDE027543A5E15D4B64399037EE29C48BA3A466F3E76'
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
