$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://d2td7dqidlhjx7.cloudfront.net/prod/global/windows/Amazon+WorkSpaces.msi'
$checksum               = '0BD8ECFDA472795E0182081B55BD6E40B606963AADEA25A709E3B6CA1A74BB4C'
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
