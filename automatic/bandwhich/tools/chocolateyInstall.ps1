$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path $MyInvocation.MyCommand.Definition

$url64      = ''
$checksum64 = ''

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