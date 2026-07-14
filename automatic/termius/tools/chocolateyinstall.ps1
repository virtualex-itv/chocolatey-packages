$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://download.termius.com/windows/Install%20Termius.exe'
$checksum               = '6108AE912A753C092B98FAEEA3F324F3F0E85370436FBF87C31A8CE843689149'
$checksumType           = 'sha256'

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
