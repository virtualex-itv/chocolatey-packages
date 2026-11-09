$ErrorActionPreference = 'Stop'

$url64      = 'https://github.com/LifetimeLabsHQ/PrivacyNotes.app/releases/download/v0.735.0/PrivacyNotes_0.735.0_x64-setup.exe'
$checksum64 = 'f82f57228d589b6d28d2a0a79853981f64bee8ce8f5aae0e48b65ab0ba6488d4'

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
