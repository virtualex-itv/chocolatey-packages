$ErrorActionPreference = 'Stop'

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://download.royalapps.com/RoyalServer/RoyalServerInstaller_5.02.50730.0.msi'
$checksum              = '1e959bd01b806c0f10e01bcb5d913e153a770bafb2a925eae74cd7a2e349e619'
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
