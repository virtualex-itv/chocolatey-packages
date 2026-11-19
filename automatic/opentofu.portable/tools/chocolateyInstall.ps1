$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path $MyInvocation.MyCommand.Definition

$url32         = 'https://github.com/opentofu/opentofu/releases/download/v1.13.9/tofu_1.13.9_windows_386.zip'
$checksum32    = '4e74f8b8758e79a36a4a6c1cd1f1e89efba9b4340860fd26f731617c175d54e6'
$url64         = 'https://github.com/opentofu/opentofu/releases/download/v1.13.9/tofu_1.13.9_windows_amd64.zip'
$checksum64    = 'b23a811741911baa829aa7d3d3718626c549e8934546822b0e9b99b9fba75e4e'
$urlArm64      = 'https://github.com/opentofu/opentofu/releases/download/v1.13.9/tofu_1.13.9_windows_arm64.zip'
$checksumArm64 = 'e5ff898e17c455fc099a46f02e3f5002d13efeb6d8e72449f7446f2a81ac9e04'

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
