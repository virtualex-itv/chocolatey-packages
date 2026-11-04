$ErrorActionPreference = 'Stop'

$url64      = 'https://github.com/Orkas-AI/Orkas/releases/download/v2026.11.4/Orkas.Setup.2.0.0.exe'
$checksum64 = '5801a45d5c2ef53104dd3e445b81bb07d2c447685689a0b0d759d29d3788281c'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  softwareName   = 'Orkas*'
  silentArgs     = '/S'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
