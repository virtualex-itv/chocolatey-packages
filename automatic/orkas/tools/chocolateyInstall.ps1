$ErrorActionPreference = 'Stop'

$url64      = 'https://github.com/Orkas-AI/Orkas/releases/download/v2026.10.27/Orkas.Setup.1.9.5.exe'
$checksum64 = '3e6c7ecb08396fd0c0a349c1bd31466542901b2bd094f2a311c21064aeaac74a'

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
