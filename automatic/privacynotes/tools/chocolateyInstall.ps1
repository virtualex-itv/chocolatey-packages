$ErrorActionPreference = 'Stop'

$url64      = 'https://github.com/LifetimeLabsHQ/PrivacyNotes.app/releases/download/v0.819.1/PrivacyNotes_0.819.1_x64-setup.exe'
$checksum64 = '85d60f4a4493f00d2b82d710ce4da5ace3e8762ac6087b6a77c52a8bc98211af'

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
