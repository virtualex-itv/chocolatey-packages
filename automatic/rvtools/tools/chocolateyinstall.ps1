$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://fdendpoint-tf-ae40cce298ca76ff-prod-a2bhbrbte7exh5d4.a01.azurefd.net/resources/prod/RVTools4.6.1.msi'
$checksum               = '1eaab4a563201384761b2fdf9c7dd0de4d8be2cef8db1faf386279ea4de8c08d'
$checksumType           = 'sha256'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'msi'
  softwareName          = 'RVTools*'
  url                   = $url
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = "/qn REBOOT=ReallySuppress"
  validExitCodes        = @(0)
}

Install-ChocolateyPackage @packageArgs
