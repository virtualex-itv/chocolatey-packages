$ErrorActionPreference = 'Stop';

$url64          = 'https://binaries.twingate.com/client/windows/versions/2026.302.9964/TwingateWindowsInstaller.msi'
$checksum64     = '9282f17c077c909ff493ba4e66462de8ce6bbb2ffb177d69ec404dc2dc6ae800'
$checksumType64 = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'msi'
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = $checksumType64
  softwareName   = 'twingate*'
  silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:ChocolateyPackageVersion).MsiInstall.log`" no_optional_updates=true"
  validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
