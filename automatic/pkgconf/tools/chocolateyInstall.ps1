$ErrorActionPreference = 'Stop'

$url32         = 'https://github.com/pkgconf/pkgconf/releases/download/pkgconf-3.0.10/pkgconf-x86-3.0.10.msi'
$checksum32    = '20afcba858f3780fb377bd52ea54f3b108ecd1e686668cf7c5cad718944afaae'
$url64         = 'https://github.com/pkgconf/pkgconf/releases/download/pkgconf-3.0.10/pkgconf-x64-3.0.10.msi'
$checksum64    = '28cc9e44473a3ef277260f3dac20f58e2a667760393bd47dc309b6426e9bd727'
$urlArm64      = 'https://github.com/pkgconf/pkgconf/releases/download/pkgconf-3.0.10/pkgconf-arm64-3.0.10.msi'
$checksumArm64 = '6447773d59fca3260304aa8fe2f01c086ed93ee0e12f2c0e5c369fc86f588a7c'

# Chocolatey runs as an emulated x64 process on ARM64 Windows, so PROCESSOR_ARCHITECTURE reads AMD64 there
$isArm64 = $env:PROCESSOR_IDENTIFIER.StartsWith('ARMv')

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'msi'
  url            = $url32
  checksum       = $checksum32
  checksumType   = 'sha256'
  url64bit       = if ($isArm64) { $urlArm64 }      else { $url64 }
  checksum64     = if ($isArm64) { $checksumArm64 } else { $checksum64 }
  checksumType64 = 'sha256'
  softwareName   = 'pkgconf*'
  silentArgs     = '/qn /norestart'
  validExitCodes = @(0, 3010, 1641)
}

# The MSI cannot replace the tools while one of them is running.
Get-Process -Name 'pkgconf', 'pkg-config', 'bomtool', 'spdxtool', 'pccritic' -ErrorAction SilentlyContinue | Stop-Process -Force

Install-ChocolateyPackage @packageArgs
