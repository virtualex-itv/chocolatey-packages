$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://dl4jz3rbrsfum.cloudfront.net/software/PPP_Windows_v2.5.1.exe'
$checksum               = 'd150d4802ca96f4699236df2e245158fc566519e48fc7b84bbdf3fbaae660060'
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
