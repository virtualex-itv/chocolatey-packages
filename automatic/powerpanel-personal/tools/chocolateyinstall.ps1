$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://dl4jz3rbrsfum.cloudfront.net/software/PPP_Windows_v2.3.4.exe'
$checksum               = '7838b776561275960f6e784bbfbf0da235e0e31191380d9b1150752188fff9a7'
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
