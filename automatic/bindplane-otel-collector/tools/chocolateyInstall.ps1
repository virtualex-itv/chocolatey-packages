$ErrorActionPreference = 'Stop'

$url64         = 'https://github.com/observIQ/bindplane-otel-collector/releases/download/v1.111.0/observiq-otel-collector.msi'
$checksum64    = '9ca7ee8d220bd06fba4529e4dee2b8854d242a7f967f37e3d1653894acee8fdd'
$urlArm64      = 'https://github.com/observIQ/bindplane-otel-collector/releases/download/v1.111.0/observiq-otel-collector-arm64.msi'
$checksumArm64 = '40a756e6773ffa975728cbbcbbedf001a02a677aaaf7c59e0b7932453cf886b1'

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
