$ErrorActionPreference = 'Stop'

$url64      = 'https://github.com/f3d-app/f3d/releases/download/v4.0.0/F3D-4.0.0-Windows-x86_64.exe'
$checksum64 = 'e6e5896bdad35e70ac3a13812c86f7017e4114542d505cabf58bcd246e060c76'
$url64Raytracing      = 'https://github.com/f3d-app/f3d/releases/download/v4.0.0/F3D-4.0.0-Windows-x86_64-raytracing.exe'
$checksum64Raytracing = '2f8f6d2af78c203240bc7e8ef165347c0e041f5474895846d0a06402ed133cc2'

$pp = Get-PackageParameters

# /Raytracing installs the larger build with raytracing support.
if ($pp.Raytracing) {
  Write-Host 'Using the F3D raytracing build (/Raytracing).'
  $url64      = $url64Raytracing
  $checksum64 = $checksum64Raytracing
}

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  softwareName   = 'F3D*'
  silentArgs     = '/S'
  validExitCodes = @(0)
}

Install-ChocolateyPackage @packageArgs

# The installer does not touch PATH, so shim the viewer and its console build.
[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']
if ($key.Count -ne 1) { throw "Expected one F3D uninstall entry, found $($key.Count)." }
$binDir = Join-Path (Split-Path ($key[0].UninstallString -replace '"', '')) 'bin'
Install-BinFile -Name 'f3d' -Path (Join-Path $binDir 'f3d.exe') -UseStart
Install-BinFile -Name 'f3d-console' -Path (Join-Path $binDir 'f3d-console.exe')
