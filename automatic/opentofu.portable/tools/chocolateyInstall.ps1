$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path $MyInvocation.MyCommand.Definition

$url32         = 'https://github.com/opentofu/opentofu/releases/download/v1.13.10/tofu_1.13.10_windows_386.zip'
$checksum32    = 'e459d385e1163d3f1aa543fe80ad9e47e2e95c60fa717da6020e9c90ed5fbca7'
$url64         = 'https://github.com/opentofu/opentofu/releases/download/v1.13.10/tofu_1.13.10_windows_amd64.zip'
$checksum64    = '643cbcb8d699a5aaf47da12ce8f9f715362f2fd84f10a407a32d44fbe2fe8e09'
$urlArm64      = 'https://github.com/opentofu/opentofu/releases/download/v1.13.10/tofu_1.13.10_windows_arm64.zip'
$checksumArm64 = '5c7279641fbe5099a000fc6815b295477775dd402997c5937b98d6ef4724cd1c'

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
