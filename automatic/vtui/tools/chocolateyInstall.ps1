$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path $MyInvocation.MyCommand.Definition

$url64         = 'https://github.com/noclue/vtui/releases/download/v0.2.10/vtui-x86_64-pc-windows-msvc.zip'
$checksum64    = '4b373897526102d87d7684f054bd5c975734b8e96e73cb510507900a3c26f2da'
$urlArm64      = 'https://github.com/noclue/vtui/releases/download/v0.2.10/vtui-aarch64-pc-windows-msvc.zip'
$checksumArm64 = '3adfea2afe11eedfa7d3d9cc594902d2bfab350a3d9632b072aa715f24c97d93'

# Chocolatey runs as an emulated x64 process on ARM64 Windows, so PROCESSOR_ARCHITECTURE reads AMD64 there
$isArm64  = $env:PROCESSOR_IDENTIFIER.StartsWith('ARMv')

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = if ($isArm64) { $urlArm64 }      else { $url64 }
  checksum      = if ($isArm64) { $checksumArm64 } else { $checksum64 }
  checksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
