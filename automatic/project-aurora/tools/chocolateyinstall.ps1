$ErrorActionPreference  = 'Stop'

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://github.com/Aurora-RGB/Aurora/releases/download/v347/Aurora-setup-v347.exe'
$checksum               = '1af073562fa0b23bfc4d0e348b032aed1ea6f3ea1a8d9031b725449a7e0a1bbd'
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
