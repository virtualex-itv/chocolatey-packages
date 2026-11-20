$ErrorActionPreference = 'Stop'

$url64         = 'https://github.com/observIQ/bindplane-otel-collector/releases/download/v1.113.0/observiq-otel-collector.msi'
$checksum64    = 'f6c4681c85943faa37297b1d8a6a658a19d2214f5c0e5d2d7aaeee065b3ed896'
$urlArm64      = 'https://github.com/observIQ/bindplane-otel-collector/releases/download/v1.113.0/observiq-otel-collector-arm64.msi'
$checksumArm64 = 'db3cf6015fbf71ad20fde3a62adad7bf17beeaf8ce7c60513ad197408f7f9cba'

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
