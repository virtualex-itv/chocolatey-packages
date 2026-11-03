$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path $MyInvocation.MyCommand.Definition

$url64      = 'https://github.com/tw93/Mole/releases/download/V1.41.0-windows/mole-1.41.0-x64.zip'
$checksum64 = 'd8e093de3b864002e39b13178818e3c3480d6978e68dc8f0c0fee8225fa757d4'

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
