$ErrorActionPreference = 'Stop'

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://download.royalapps.com/RoyalServer/RoyalServerInstaller_5.04.51103.0.msi'
$checksum              = '4c290330df1faa5218da72567174d24dc4012af3449d4d0662054fc45d5e7c64'
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
