$ErrorActionPreference = 'Stop'

$url64         = 'https://github.com/observIQ/bindplane-otel-collector/releases/download/v1.113.1/observiq-otel-collector.msi'
$checksum64    = '44f7d8bfadcd8c43ab41ad231b21a03521700d023917a81714bf51e66e63e53f'
$urlArm64      = 'https://github.com/observIQ/bindplane-otel-collector/releases/download/v1.113.1/observiq-otel-collector-arm64.msi'
$checksumArm64 = '6bb8432883f62be8fe2e3d69922dd725b06ca801a7c51ef990a6aada0fa2d6e9'

# Chocolatey runs as an emulated x64 process on ARM64 Windows, so PROCESSOR_ARCHITECTURE reads AMD64 there
$isArm64 = $env:PROCESSOR_IDENTIFIER.StartsWith('ARMv')

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'msi'
  url64bit       = if ($isArm64) { $urlArm64 }      else { $url64 }
  checksum64     = if ($isArm64) { $checksumArm64 } else { $checksum64 }
  checksumType64 = 'sha256'
  softwareName   = 'observIQ Distro for OpenTelemetry Collector*'
  silentArgs     = '/qn /norestart'
  validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
