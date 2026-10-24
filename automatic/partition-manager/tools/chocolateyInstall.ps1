$ErrorActionPreference = 'Stop'

$url64            = 'https://dl.paragon-software.com/demo/Paragon-1081-FRU_WinInstallDemo_x64.exe'
$checksum64       = '9aeab1d0cb0bf25431b2d3298df5f8a6326b479d54f21aa854d3de9be86f85d3'
$urlArm64         = 'https://dl.paragon-software.com/demo/Paragon-1081-FRU_WinInstallDemo_arm64.exe'
$checksumArm64    = '877500c7b506788994064a11b95885aad6cf407c112e60a58702a46a7eb1f906'

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
