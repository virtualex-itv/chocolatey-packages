$ErrorActionPreference = 'Stop'

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://download.royalapps.com/RoyalServer/RoyalServerInstaller_4.01.60216.0.msi'
$checksum              = '506db255a3293daf6bb1bd3ecbb9d2a0684380a008b25253674f61e1743502ad'
$checksumType          = 'sha256'

$packageArgs = @{
  packageName        = $env:ChocolateyPackageName
  unzipLocation      = $toolsDir
  fileType           = 'msi'
  softwareName       = "Royal Server*"
  url                = $url
  checksum           = $checksum
  checksumType       = $checksumType
  silentArgs         = '/qn /norestart'
  validExitCodes     = @(0, 3010)
}

Install-ChocolateyPackage @packageArgs
