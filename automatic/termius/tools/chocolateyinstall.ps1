$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://autoupdate.termius.com/windows/Install%20Termius.exe'
$checksum               = '8d5a1f03a9bb4c035b73334eb58acf811bc8827941a97d497a3500b55df9037677cfea04bb833c879a47b554d5d4179199aab34818d9dfd39ae9a963f9d9f898'
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
