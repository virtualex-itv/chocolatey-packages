$ErrorActionPreference = 'Stop'

$url64      = 'https://github.com/ktgw0316/LightZone/releases/download/v5.0.3/LightZone-5.0.3-20261022T033611-windows-64bit.msi'
$checksum64 = '2dcf80a9eb8e1acf094b3fb0e26ad818f600fcd4f075f8a9fd8f8de3ddeb3be7'

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
