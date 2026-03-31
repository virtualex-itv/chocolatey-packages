$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path $MyInvocation.MyCommand.Definition

$url64         = 'https://github.com/noclue/vtui/releases/download/v0.2.3/vtui-x86_64-pc-windows-msvc.zip'
$checksum64    = 'b33f4b74a6c1d93c91c9562ff4feb296532b0897fa89de53be26b7267a82e803'
$urlArm64      = 'https://github.com/noclue/vtui/releases/download/v0.2.3/vtui-aarch64-pc-windows-msvc.zip'
$checksumArm64 = '4e0b25fcb354a6c1d937bbaad995129b58415fd236ba7720bd7e3eb92648543a'

$isArm64  = $env:PROCESSOR_ARCHITECTURE -eq 'ARM64'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = if ($isArm64) { $urlArm64 }      else { $url64 }
  checksum      = if ($isArm64) { $checksumArm64 } else { $checksum64 }
  checksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
