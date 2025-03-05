$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://d2td7dqidlhjx7.cloudfront.net/prod/global/windows/Amazon+WorkSpaces.msi'
$checksum               = '307E094AC6ADD2A027B18FF70DFF7EA5F7A75272BB96D1481B19581E873F081D'
$checksumType           = 'sha256'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'msi'
  softwareName          = "Amazon WorkSpaces*"
  url                   = $url
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = '/qn REBOOT=ReallySuppress'
  validExitCodes        = @(0)
}

Install-ChocolateyPackage @packageArgs
