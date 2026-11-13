$ErrorActionPreference = 'Stop'

$url64      = 'https://github.com/ktgw0316/LightZone/releases/download/v5.1.0/LightZone-5.1.0-20261113T142741-windows-64bit.msi'
$checksum64 = '993096e8eda37af5d323f4bf3284bfb71036460e961c8074cd6415c7585a3875'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'msi'
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  softwareName   = 'LightZone*'
  silentArgs     = '/qn /norestart'
  validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
