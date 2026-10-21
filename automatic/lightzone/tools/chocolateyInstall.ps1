$ErrorActionPreference = 'Stop'

$url64      = 'https://github.com/ktgw0316/LightZone/releases/download/v5.0.2/LightZone-5.0.2-20260806T134609-windows-64bit.msi'
$checksum64 = 'b674ff03168f54dbc44b73bf1d51ff5b36a492fa696c9e5db727f4e82ea0f10d'

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
