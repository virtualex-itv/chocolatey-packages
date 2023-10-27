$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://d2td7dqidlhjx7.cloudfront.net/prod/global/windows/Amazon+WorkSpaces.msi'
$checksum               = '9F6FBB509FC4564A516E2249ACB055A22AC6D4D1E416BB64218C8E2CD55C2DF2'
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
