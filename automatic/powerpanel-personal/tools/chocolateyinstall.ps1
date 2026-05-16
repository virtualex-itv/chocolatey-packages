$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://dl4jz3rbrsfum.cloudfront.net/software/PPP_Windows_v2.7.1.exe'
$checksum               = 'a67b971243df08c0d8cdadf430484cd4bdb7cbd73e4154850563ad6dc46b5784'
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
