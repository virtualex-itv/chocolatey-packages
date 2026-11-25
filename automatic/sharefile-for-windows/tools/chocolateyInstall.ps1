$ErrorActionPreference = 'Stop'

$url64         = 'https://dl.sharefile.com/sfwin-msi-x64/ShareFileForWindows_x64_v26.3.12.0.msi'
$checksum64    = 'f47fd55d18370b8acd75190b4684431f0ee0946994be9ed35b95514011105cf0'
$urlArm64      = 'https://dl.sharefile.com/sfwin-msi-arm64/ShareFileForWindows_ARM64_v26.3.12.0.msi'
$checksumArm64 = 'a98cc04f61554a1d9f2df1d96b8805e0a2b1b1660fcfe127ea7dee3abe6acedc'

if (-not [Environment]::Is64BitOperatingSystem) { throw 'ShareFile publishes no 32-bit installer for ShareFile for Windows.' }

# Chocolatey runs as an emulated x64 process on ARM64 Windows, so PROCESSOR_ARCHITECTURE reads AMD64 there
$isArm64 = $env:PROCESSOR_IDENTIFIER.StartsWith('ARMv')

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'msi'
  url64bit       = if ($isArm64) { $urlArm64 }      else { $url64 }
  checksum64     = if ($isArm64) { $checksumArm64 } else { $checksum64 }
  checksumType64 = 'sha256'
  softwareName   = 'ShareFile'
  silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:ChocolateyPackageVersion).MsiInstall.log`""
  validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs

# The MSI starts the Visual C++ runtime installer in the background and returns; wait for it so the next MSI install does not fail with 1618.
function Test-InstallerBusy {
  $mutex = $null
  $busy = [Threading.Mutex]::TryOpenExisting('Global\_MSIExecute', [ref]$mutex)
  if ($mutex) { $mutex.Dispose() }
  $busy -or [bool](Get-CimInstance Win32_Process -Filter "CommandLine LIKE '%vc[_]redist%' OR CommandLine LIKE '%vcredist%'" -ErrorAction SilentlyContinue)
}

$deadline = (Get-Date).AddMinutes(10)
$freeChecks = 0
while ($freeChecks -lt 3 -and (Get-Date) -lt $deadline) {
  Start-Sleep -Seconds 5
  if (Test-InstallerBusy) { $freeChecks = 0 } else { $freeChecks++ }
}
if ($freeChecks -lt 3) { Write-Warning 'Windows Installer is still busy 10 minutes after the ShareFile install; the next MSI install may fail with 1618 until it finishes.' }
