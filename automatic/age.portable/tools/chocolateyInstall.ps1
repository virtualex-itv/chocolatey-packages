$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path $MyInvocation.MyCommand.Definition

$url64         = 'https://github.com/FiloSottile/age/releases/download/v1.3.2/age-v1.3.2-windows-amd64.zip'
$checksum64    = 'f48d8f8f9ebe903ab5027ed067652f2cc1db94bc206976430133b905dcd8e8c7'
$urlArm64      = 'https://github.com/FiloSottile/age/releases/download/v1.3.2/age-v1.3.2-windows-arm64.zip'
$checksumArm64 = 'fae351336c8d5f30f93cc3ccdec16d1ed7851d68cdd6656d41955cc31a447c9d'

if (-not [Environment]::Is64BitOperatingSystem) { throw 'age publishes no 32-bit Windows build.' }

# Chocolatey runs as an emulated x64 process on ARM64 Windows, so PROCESSOR_ARCHITECTURE reads AMD64 there
$isArm64 = $env:PROCESSOR_IDENTIFIER.StartsWith('ARMv')

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = if ($isArm64) { $urlArm64 }      else { $url64 }
  checksum      = if ($isArm64) { $checksumArm64 } else { $checksum64 }
  checksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
