$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://dl4jz3rbrsfum.cloudfront.net/software/PPP_Windows_v2.4.6.exe'
$checksum               = '5122c01046add97cd080700862d107a8b7e362357f6731ab81520e95ee6ddd84'
$checksumType           = 'sha256'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  softwareName          = "CyberPower PowerPanel Personal*"
  url                   = $url
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = '-q'
  validExitCodes        = @(0)
}

Install-ChocolateyPackage @packageArgs
