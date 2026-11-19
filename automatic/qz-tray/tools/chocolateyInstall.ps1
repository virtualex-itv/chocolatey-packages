$ErrorActionPreference = 'Stop'

$url64         = 'https://github.com/qzind/tray/releases/download/v2.3.0/qz-tray-2.3.0%2B1-x86_64.exe'
$checksum64    = '01a8ae33da31c78f386ef8335024723f2dd2cb7d8bc44ce33079bf6bc0360011'
$urlArm64      = 'https://github.com/qzind/tray/releases/download/v2.3.0/qz-tray-2.3.0%2B1-arm64.exe'
$checksumArm64 = '76ce2e492779589e2a61697344ba0b871ec8ec67942c9e08c5a1c9d90f5119c5'

if (-not [Environment]::Is64BitOperatingSystem) { throw 'QZ Tray publishes no 32-bit Windows build.' }

# Chocolatey runs as an emulated x64 process on ARM64 Windows, so PROCESSOR_ARCHITECTURE reads AMD64 there
$isArm64 = $env:PROCESSOR_IDENTIFIER.StartsWith('ARMv')

# The installer bundles its own Java runtime, stops any running QZ Tray first and starts QZ Tray for the logged-on user when done.
$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url64bit       = if ($isArm64) { $urlArm64 }      else { $url64 }
  checksum64     = if ($isArm64) { $checksumArm64 } else { $checksum64 }
  checksumType64 = 'sha256'
  softwareName   = 'QZ Tray*'
  silentArgs     = '/S'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs
