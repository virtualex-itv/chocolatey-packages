$ErrorActionPreference = 'Stop'

$url64      = 'https://zoom.us/download/vdi/7.0.14.27210/ZoomVDIUniversalPluginx64.msi?archType=x64'
$checksum64 = 'e7c71ced634cdeaa0058626deedcdc7d9162ee5b18a04ea5ba2c2b9b7d44ad4d'

if (-not [Environment]::Is64BitOperatingSystem) { throw 'Zoom publishes no 32-bit VDI plugin installer.' }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'msi'
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  softwareName   = 'Zoom VDI Universal Plugin*'
  silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:ChocolateyPackageVersion).MsiInstall.log`""
  validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
