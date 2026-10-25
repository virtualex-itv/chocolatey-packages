$ErrorActionPreference = 'Stop'

$url64      = 'https://github.com/LifetimeLabsDev/PrivacyNotes.app/releases/download/v0.696.1/PrivacyNotes_0.696.1_x64-setup.exe'
$checksum64 = '3a7551bac9a1150ce060f34a4fbcd5ddb0bc92f8a78531260ecf0d12a52471a1'

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
