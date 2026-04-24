$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path $MyInvocation.MyCommand.Definition

$url64         = 'https://github.com/noclue/vtui/releases/download/v0.2.5/vtui-x86_64-pc-windows-msvc.zip'
$checksum64    = 'c6977f8376e16b02217327b08298eb61c9ae6d8a5944889c7ce90306baa7012e'
$urlArm64      = 'https://github.com/noclue/vtui/releases/download/v0.2.5/vtui-aarch64-pc-windows-msvc.zip'
$checksumArm64 = '59f1d888b1d8f18dad679bed282071e923284dde2b54e28e679005e0696ff3ad'

$isArm64  = $env:PROCESSOR_ARCHITECTURE -eq 'ARM64'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = if ($isArm64) { $urlArm64 }      else { $url64 }
  checksum      = if ($isArm64) { $checksumArm64 } else { $checksum64 }
  checksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
