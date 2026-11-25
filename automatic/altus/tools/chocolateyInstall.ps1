$ErrorActionPreference = 'Stop'

$url64      = 'https://github.com/amanharwara/altus/releases/download/5.8.4/Altus-Setup-5.8.4.exe'
$checksum64 = '88b4cc8d0a725c328ffa557e702224a94c71e2d86d4e0f4ba7c752e7e13d9808'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  softwareName   = 'Altus*'
  silentArgs     = '/S'
  validExitCodes = @(0)
}

# The installer cannot replace files of a running Altus.
Get-Process -Name 'Altus' -ErrorAction SilentlyContinue | Stop-Process -Force

Install-ChocolateyPackage @packageArgs
