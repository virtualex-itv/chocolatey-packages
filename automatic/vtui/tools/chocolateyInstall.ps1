$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path $MyInvocation.MyCommand.Definition

$url64         = 'https://github.com/noclue/vtui/releases/download/v0.2.7/vtui-x86_64-pc-windows-msvc.zip'
$checksum64    = 'c4e178917dc452b5b666c91b7127c5c8647467ea0585dab4e39a288a9f8d80fd'
$urlArm64      = 'https://github.com/noclue/vtui/releases/download/v0.2.7/vtui-aarch64-pc-windows-msvc.zip'
$checksumArm64 = '68dae987008461d35fa5ee738b18c6fdbc053c62dc75f545203e601f9cf02a0e'

$isArm64  = $env:PROCESSOR_ARCHITECTURE -eq 'ARM64'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = if ($isArm64) { $urlArm64 }      else { $url64 }
  checksum      = if ($isArm64) { $checksumArm64 } else { $checksum64 }
  checksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
