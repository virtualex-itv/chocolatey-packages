$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path $MyInvocation.MyCommand.Definition

$url64         = 'https://github.com/noclue/vtui/releases/download/v0.2.6/vtui-x86_64-pc-windows-msvc.zip'
$checksum64    = '3cd8e0eb8ac6b6ff40e3609ff3b812bcb85730bffb1adbb129b3d07eb488cb15'
$urlArm64      = 'https://github.com/noclue/vtui/releases/download/v0.2.6/vtui-aarch64-pc-windows-msvc.zip'
$checksumArm64 = '8f743cbf73e9cc5f31d98e41ac691d9b295fa863ffc30bbf5fa6ba0c7347ce59'

$isArm64  = $env:PROCESSOR_ARCHITECTURE -eq 'ARM64'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = if ($isArm64) { $urlArm64 }      else { $url64 }
  checksum      = if ($isArm64) { $checksumArm64 } else { $checksum64 }
  checksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
