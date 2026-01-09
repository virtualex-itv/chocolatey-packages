$ErrorActionPreference = 'Stop'

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://download.royalapps.com/RoyalServer/RoyalServerInstaller_5.03.60108.0.msi'
$checksum              = 'ab44ff76eb9c9a2bce4afc11bf9b88a9a3acf078d1af33cd6cd9cc4452221eef'
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
