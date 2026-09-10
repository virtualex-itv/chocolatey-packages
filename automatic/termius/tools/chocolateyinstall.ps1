$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://autoupdate.termius.com/windows/Install%20Termius.exe'
$checksum               = '8d0547f03bc720d6f581ae843f6d10b0a34f8941f71f388ceb1d5777eb6122a996b0d02de55ea4dd595cdc1f3a9d8b7a2ff027ccbac9926840a107f80d2f0ace'
$checksumType           = 'sha512'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  softwareName          = 'Termius*'
  url                   = $url
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = '/S'
  validExitCodes        = @(0)
}

Install-ChocolateyPackage @packageArgs
