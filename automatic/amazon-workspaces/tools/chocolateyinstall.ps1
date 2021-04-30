$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://d2td7dqidlhjx7.cloudfront.net/prod/global/windows/Amazon+WorkSpaces.msi'
$checksum               = '864A53515EAF1CCA72BFC9693BF954B67D9A2B39FD66F96327BF78EE7FE94A25'
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
