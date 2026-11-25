$ErrorActionPreference = 'Stop'

$url64      = 'https://zoom.us/download/vdi/7.0.14.27210/ZoomInstallerVDI.msi?archType=x64'
$checksum64 = '60c038a757dc6cbcbf97b0160e9be294ba3d5084609532c746848dd9f45dac0c'

if (-not [Environment]::Is64BitOperatingSystem) { throw 'Zoom publishes no 32-bit VDI client installer.' }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'msi'
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  softwareName   = 'Zoom VDI Workplace*'
  silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:ChocolateyPackageVersion).MsiInstall.log`""
  validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
