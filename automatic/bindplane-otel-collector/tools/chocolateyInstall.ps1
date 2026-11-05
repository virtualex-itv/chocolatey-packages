$ErrorActionPreference = 'Stop'

$url64         = 'https://github.com/observIQ/bindplane-otel-collector/releases/download/v1.112.0/observiq-otel-collector.msi'
$checksum64    = '7bdf657b0be87d8079214daaac49c7cf29d78093cd60801a92b0adab1e52d3f8'
$urlArm64      = 'https://github.com/observIQ/bindplane-otel-collector/releases/download/v1.112.0/observiq-otel-collector-arm64.msi'
$checksumArm64 = '2430109e231f1444ce2cf4a46710149276fb04ebe2e47ebed136d2d298cb0393'

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
