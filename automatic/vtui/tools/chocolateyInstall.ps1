$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path $MyInvocation.MyCommand.Definition

$url64         = 'https://github.com/noclue/vtui/releases/download/v0.2.9/vtui-x86_64-pc-windows-msvc.zip'
$checksum64    = '4270a48fd83d8ccd4e9807af3a51b28e159ebf5772e27bde838ee62d901ac16c'
$urlArm64      = 'https://github.com/noclue/vtui/releases/download/v0.2.9/vtui-aarch64-pc-windows-msvc.zip'
$checksumArm64 = 'd57a72e96e4c2e30b2127acfe286ae0c3c57c0ba67f03999f66686245fdc3560'

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
