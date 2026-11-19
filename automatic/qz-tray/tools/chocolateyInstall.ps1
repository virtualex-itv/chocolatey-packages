$ErrorActionPreference = 'Stop'

$url64         = ''
$checksum64    = ''
$urlArm64      = ''
$checksumArm64 = ''

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
