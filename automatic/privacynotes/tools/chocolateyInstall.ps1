$ErrorActionPreference = 'Stop'

$url64      = 'https://github.com/LifetimeLabsHQ/PrivacyNotes.app/releases/download/v0.780.8/PrivacyNotes_0.780.8_x64-setup.exe'
$checksum64 = '781c56e4ebdd456ac4a50789117fb00e557112f0b26a93f1a17c23fd8e3e2321'

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
