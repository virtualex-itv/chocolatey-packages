$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path $MyInvocation.MyCommand.Definition

$url64         = ''
$checksum64    = ''
$urlArm64      = ''
$checksumArm64 = ''

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
