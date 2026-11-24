$ErrorActionPreference = 'Stop'

$url64      = 'https://github.com/ktgw0316/LightZone/releases/download/v5.1.1/LightZone-5.1.1-20261124T120341-windows-64bit.msi'
$checksum64 = 'b11cd920b6bf004739b87a20b544a1a65138c4b59c4e5be3c53af53615798db3'

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
