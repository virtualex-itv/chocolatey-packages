$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://autoupdate.termius.com/windows/Termius.exe'
$checksum               = '02D6F8F80C6613375223038DDAAFA8371B747AE94F80A6434D4420F3ACB61052'
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
