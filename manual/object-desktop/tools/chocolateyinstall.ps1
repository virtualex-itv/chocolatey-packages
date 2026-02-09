$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://stardock.cachefly.net/software/ObjectDesktop/ObjectDesktop_4.07-j113-Setup.exe'
$checksum               = 'a1552a6e0147229fd4b6d40d55f6b0230051160ec64292aa2c12eefec5535de5'
$checksumType           = 'sha256'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  softwareName          = "Stardock Object Desktop*"
  url                   = $url
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = '/s'
  validExitCodes        = @(0)
}

Install-ChocolateyPackage @packageArgs
