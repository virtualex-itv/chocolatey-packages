$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path $MyInvocation.MyCommand.Definition

$url64         = 'https://github.com/BetterDiscord/cli/releases/download/v1.0.0/bdcli_1.0.0_windows_amd64.zip'
$checksum64    = '4cc9ebf30c99311caf72ba2fad90d6c4a5ce2b77be4b83f7de8589d5de023b80'
$urlArm64      = 'https://github.com/BetterDiscord/cli/releases/download/v1.0.0/bdcli_1.0.0_windows_arm64.zip'
$checksumArm64 = '60838d7f7e4d6a70c76dedeee1e84bd551f3e32691cad8a690d6c08661131769'

# Chocolatey runs as an emulated x64 process on ARM64 Windows, so PROCESSOR_ARCHITECTURE reads AMD64 there
$isArm64 = $env:PROCESSOR_IDENTIFIER.StartsWith('ARMv')

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = if ($isArm64) { $urlArm64 }      else { $url64 }
  checksum      = if ($isArm64) { $checksumArm64 } else { $checksum64 }
  checksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
