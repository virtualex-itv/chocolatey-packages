$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path $MyInvocation.MyCommand.Definition

$url64         = 'https://github.com/noclue/vtui/releases/download/v0.2.4/vtui-x86_64-pc-windows-msvc.zip'
$checksum64    = '12ab0dff4abc0d65c715ca0641a90d01c1c82e130d198040cbc181859adfb149'
$urlArm64      = 'https://github.com/noclue/vtui/releases/download/v0.2.4/vtui-aarch64-pc-windows-msvc.zip'
$checksumArm64 = '774dfe68ed3721a7a0fc69f23275d1d97eff5ef1b4c331bd74fadc93a32fc6a6'

$isArm64  = $env:PROCESSOR_ARCHITECTURE -eq 'ARM64'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = if ($isArm64) { $urlArm64 }      else { $url64 }
  checksum      = if ($isArm64) { $checksumArm64 } else { $checksum64 }
  checksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
