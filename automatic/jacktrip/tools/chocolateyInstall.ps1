$ErrorActionPreference = 'Stop'

$url64      = 'https://github.com/jacktrip/jacktrip/releases/download/v3.0.1/JackTrip-v3.0.1-Windows-x64-installer.msi'
$checksum64 = '522bc454559d34854a6f18e7f37ab147674755a395b814fc2c203bf43246ae43'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  fileType       = 'msi'
  url64bit       = $url64
  checksum64     = $checksum64
  checksumType64 = 'sha256'
  softwareName   = 'JackTrip*'
  silentArgs     = '/qn /norestart'
  validExitCodes = @(0, 3010, 1641)
}

# The MSI replaces files that a running JackTrip holds open.
Get-Process -Name 'jacktrip' -ErrorAction SilentlyContinue | Stop-Process -Force

Install-ChocolateyPackage @packageArgs

# The MSI starts JackTrip itself on a fresh install, even when silent, so close it again.
for ($i = 0; $i -lt 10; $i++) {
  $started = Get-Process -Name 'jacktrip' -ErrorAction SilentlyContinue
  if ($started) { $started | Stop-Process -Force; break }
  Start-Sleep -Seconds 1
}
