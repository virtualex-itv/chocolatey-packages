$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path $MyInvocation.MyCommand.Definition

$url64      = 'https://github.com/imsnif/bandwhich/releases/download/v0.23.1/bandwhich-v0.23.1-x86_64-pc-windows-msvc.zip'
$checksum64 = '684d87acfd0fa808700500c2d4ced2a60be222dd86adc671035ad7b84c42cda4'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs

if (-not (Test-Path "$env:SystemRoot\System32\Npcap\wpcap.dll") -and -not (Test-Path "$env:SystemRoot\System32\wpcap.dll")) {
  Write-Warning 'Npcap was not found. bandwhich needs it to capture packets; install it from https://npcap.com/#download (WinPcap API-compatible mode).'
}
