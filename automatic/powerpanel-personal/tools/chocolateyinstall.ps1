$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://dl4jz3rbrsfum.cloudfront.net/software/PPP_Windows_v2.6.1.exe'
$checksum               = '92b4cb28c6b7a06d4091892311088d81e7bfbf52869af7881ad8735239f3d5f6'
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
