$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://autoupdate.termius.com/windows/Install%20Termius.exe'
$checksum               = '1acede353ce3bab569e4e91d9091a840a5627c50b53c3b1ed32efd7af6954c5a56f404c3b4a45fb814dfd30970e09ce5ef6c271e678d87632ad4d899af5bdca0'
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
