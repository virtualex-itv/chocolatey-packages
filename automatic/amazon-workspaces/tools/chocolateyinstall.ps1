$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://d2td7dqidlhjx7.cloudfront.net/prod/global/windows/Amazon+WorkSpaces.msi'
$checksum               = 'ACFABF83EA29929D58289CEF9FC49000C127F5245A0E80C6B85E2DB9B44A5298'
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
