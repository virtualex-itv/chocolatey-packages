$ErrorActionPreference = 'Stop'

$url64      = 'https://github.com/Orkas-AI/Orkas/releases/download/v2026.10.17/Orkas.Setup.1.9.0.exe'
$checksum64 = '3ea85710c3600c9086de9f753d4aa57ed80ed69e031fd25507ff15778133f318'

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
