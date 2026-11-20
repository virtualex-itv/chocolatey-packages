$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path $MyInvocation.MyCommand.Definition

$url32         = 'https://github.com/opentofu/opentofu/releases/download/v1.12.12/tofu_1.12.12_windows_386.zip'
$checksum32    = '41470611e25aaa4b550980f492792b151cb7f5da12623639aa5b6a88eedc82da'
$url64         = 'https://github.com/opentofu/opentofu/releases/download/v1.12.12/tofu_1.12.12_windows_amd64.zip'
$checksum64    = '237c29f25bee7e6606ab07fd7c09c6ae90b41466b0d9e4bdd53e499c627d7b96'
$urlArm64      = 'https://github.com/opentofu/opentofu/releases/download/v1.12.12/tofu_1.12.12_windows_amd64.zip'
$checksumArm64 = '237c29f25bee7e6606ab07fd7c09c6ae90b41466b0d9e4bdd53e499c627d7b96'

# Chocolatey runs as an emulated x64 process on ARM64 Windows, so PROCESSOR_ARCHITECTURE reads AMD64 there
$isArm64 = $env:PROCESSOR_IDENTIFIER.StartsWith('ARMv')

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  url            = $url32
  checksum       = $checksum32
  checksumType   = 'sha256'
  url64bit       = if ($isArm64) { $urlArm64 }      else { $url64 }
  checksum64     = if ($isArm64) { $checksumArm64 } else { $checksum64 }
  checksumType64 = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
