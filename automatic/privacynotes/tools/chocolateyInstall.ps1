$ErrorActionPreference = 'Stop'

$url64      = 'https://github.com/LifetimeLabsHQ/PrivacyNotes.app/releases/download/v0.847.1/PrivacyNotes_0.847.1_x64-setup.exe'
$checksum64 = 'd4042472ec4d3bd5a59112698df57590e9ab5147d235674764bb97e610a499ff'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'exe'
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  softwareName   = 'PrivacyNotes*'
  silentArgs     = '/S'
  validExitCodes = @(0)
}

# The installer cannot replace files of a running PrivacyNotes.
Get-Process -Name 'PrivacyNotes' -ErrorAction SilentlyContinue | Stop-Process -Force

Install-ChocolateyPackage @packageArgs
