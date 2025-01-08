$ErrorActionPreference = 'Stop'

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://download.royalapps.com/RoyalServer/RoyalServerInstaller_5.03.50107.0.msi'
$checksum              = 'f8bcfbca3cec2ec915dc2c01fe9d7d13e1d7b25d38cc92b12a1d8bbd992c372e'
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
