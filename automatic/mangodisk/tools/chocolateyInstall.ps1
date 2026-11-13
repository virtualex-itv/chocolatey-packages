$ErrorActionPreference = 'Stop'

$url64      = 'https://github.com/harry0703/MangoDisk/releases/download/v2.0.0/MangoDisk-2.0.0-windows.exe'
$checksum64 = '05117663abb026b1204fe1fcedf05d7b8d3d745f88b7b5a3ab5c2e3079148428'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  softwareName   = 'MangoDisk*'
  silentArgs     = '/S'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
