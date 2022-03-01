$ErrorActionPreference = 'Stop'

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = ''
$checksum              = ''
$checksumType          = ''

$packageArgs = @{
  packageName        = $env:ChocolateyPackageName
  unzipLocation      = $toolsDir
  fileType           = 'exe'
  softwareName       = "Logitech G HUB*"
  url                = $url
  checksum           = $checksum
  checksumType       = $checksumType
  silentArgs         = '/qn /norestart'
  validExitCodes     = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
