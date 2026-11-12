$ErrorActionPreference = 'Stop'

$url64      = 'https://github.com/LifetimeLabsHQ/PrivacyNotes.app/releases/download/v0.757.0/PrivacyNotes_0.757.0_x64-setup.exe'
$checksum64 = '0703bc2ebe3292e1037af0811d80566bcea1984f34a1d3e6198ef5aab8088bca'

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
