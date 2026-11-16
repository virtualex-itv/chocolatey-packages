$ErrorActionPreference = 'Stop'

$url64      = 'https://github.com/Orkas-AI/Orkas/releases/download/v2026.11.16/Orkas.Setup.2.5.0.exe'
$checksum64 = '3b32fc5bce6f1bff4bfe66090d0155feef99837f2d5a2550d055986164d80028'

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
