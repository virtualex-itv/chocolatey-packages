$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://download.termius.com/windows/Install%20Termius.exe'
$checksum               = '9D6FB0B32FCEF989762E7C268F298EBCFB46E042920847681418E38A1A6752D0'
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
