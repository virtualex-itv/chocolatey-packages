$ErrorActionPreference  = 'Stop'

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://github.com/Aurora-RGB/Aurora/releases/download/v117/Aurora-setup-v117.exe'
$checksum               = '42f6a0a037a381ea6cd3658f88b26a28a735cd2dc1d0801ace6d4aba0e51402f'
$checksumType           = 'sha256'
$pp                     = Get-PackageParameters

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
