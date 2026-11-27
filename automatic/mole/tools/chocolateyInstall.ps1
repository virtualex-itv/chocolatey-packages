$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path $MyInvocation.MyCommand.Definition

$url64      = 'https://github.com/tw93/Mole/releases/download/V1.47.0-windows/mole-1.47.0-x64.zip'
$checksum64 = 'fdb3914ed3fa3592367bad8e68164f897032d66a0a69b26a8e1662f8efa1a149'

if (-not [Environment]::Is64BitOperatingSystem) { throw 'Mole is only released for 64-bit Windows.' }

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = $url64
  checksum      = $checksum64
  checksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs

# bin\analyze.exe and bin\status.exe are internal helpers that mo.exe calls; keep them off the PATH.
foreach ($helper in 'analyze', 'status') {
  New-Item -ItemType File -Path (Join-Path $toolsDir "bin\$helper.exe.ignore") -Force | Out-Null
}

# Scoop exposes the same alias; mo.exe is shimmed as 'mo' automatically.
Install-BinFile -Name 'mole' -Path (Join-Path $toolsDir 'mo.exe')
