$ErrorActionPreference = 'Stop'

$url64      = 'https://github.com/Tormak9970/Steam-Art-Manager/releases/download/v3.23.2/steam-art-manager.msi'
$checksum64 = '2b007ee0b2598fe84b0a7076054928b6dc922b0d8f76b31263320546ecd90c04'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'msi'
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  softwareName   = 'Steam Art Manager*'
  silentArgs     = '/qn /norestart'
  validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
