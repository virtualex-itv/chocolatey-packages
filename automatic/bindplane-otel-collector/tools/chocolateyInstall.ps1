$ErrorActionPreference = 'Stop'

$url64         = 'https://github.com/observIQ/bindplane-otel-collector/releases/download/v1.110.2/observiq-otel-collector.msi'
$checksum64    = '45ac454fa89c9e1decdcd751f23d2aae29b07bb8c2164c2297036da5a75127ad'
$urlArm64      = 'https://github.com/observIQ/bindplane-otel-collector/releases/download/v1.110.2/observiq-otel-collector-arm64.msi'
$checksumArm64 = 'd3ac8b3d6fec839e96a6d1d315a6d0d977db6245da5d86b87a5009beab7f9bd2'

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
