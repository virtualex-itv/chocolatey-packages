$ErrorActionPreference  = 'Stop'

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://github.com/Aurora-RGB/Aurora/releases/download/v275/Aurora-setup-v275.exe'
$checksum               = '6ecb6e8240907df85c95ea6d3f0fc88494f14b7ec393971e3c32f8941caf73cd'
$checksumType           = 'sha256'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  softwareName          = 'Aurora*'
  url                   = $url
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = '/SP- /VERYSILENT /NORESTART'
  validExitCodes        = @(0, 3010, 1605, 1614, 1641)
}

Install-ChocolateyPackage @packageArgs
