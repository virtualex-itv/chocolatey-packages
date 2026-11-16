$ErrorActionPreference = 'Stop'

$url32         = 'https://github.com/pkgconf/pkgconf/releases/download/pkgconf-3.0.11/pkgconf-x86-3.0.11.msi'
$checksum32    = '28c42be439ff8092b9420fcd2585b21d760a88a5681c049d24c195dd1c584536'
$url64         = 'https://github.com/pkgconf/pkgconf/releases/download/pkgconf-3.0.11/pkgconf-x64-3.0.11.msi'
$checksum64    = 'ea99c87ab4a3dd8799d47ef196f66ca57d274ec4f49b25d2f48b7c9d9df0eb96'
$urlArm64      = 'https://github.com/pkgconf/pkgconf/releases/download/pkgconf-3.0.11/pkgconf-arm64-3.0.11.msi'
$checksumArm64 = 'dfcad622e15fe712ddc39110117a5dc7ba8e3a681c326e2ae04a484766054c45'

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
