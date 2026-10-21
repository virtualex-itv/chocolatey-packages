$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path $MyInvocation.MyCommand.Definition

$url64         = 'https://github.com/noclue/vtui/releases/download/v0.2.8/vtui-x86_64-pc-windows-msvc.zip'
$checksum64    = '1a5ca123e7edf113aacc5a13f5b356f1ec47c6cbf16dc1718f5bbb3e7183599f'
$urlArm64      = 'https://github.com/noclue/vtui/releases/download/v0.2.8/vtui-aarch64-pc-windows-msvc.zip'
$checksumArm64 = '26787b61beab2934c0dabf891dc39866dd2d6fb6c4bcb6ef40602123e88ff4d3'

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
