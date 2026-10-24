$ErrorActionPreference = 'Stop'

$url64            = ''
$checksum64       = ''
$urlArm64         = ''
$checksumArm64    = ''

# Chocolatey runs as an emulated x64 process on ARM64 Windows, so read the CPU name instead of PROCESSOR_ARCHITECTURE.
$isArm64 = $env:PROCESSOR_IDENTIFIER.StartsWith('ARMv')

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url64bit       = if ($isArm64) { $urlArm64 } else { $url64 }
  checksum64     = if ($isArm64) { $checksumArm64 } else { $checksum64 }
  checksumType64 = 'sha256'
  softwareName   = 'Paragon Partition Manager*'
  silentArgs     = '/quiet /norestart'
  validExitCodes = @(0, 3010)
}

Install-ChocolateyPackage @packageArgs

Write-Warning 'On first launch Paragon Partition Manager asks you to sign in with a Google or Microsoft account to start an evaluation period. It is free for personal and home use only.'
