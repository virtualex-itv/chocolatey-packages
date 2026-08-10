$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://autoupdate.termius.com/windows/Install%20Termius.exe'
$checksum               = '71e7a8b5d2c19188752bb2a0f5ea84430a2fe1f864dc770e9d80640aed505ef57d9603469d91849c799475b73d94afead3c3e9821c968b22af1406fa730d174b'
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
