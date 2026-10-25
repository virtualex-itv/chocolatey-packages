$ErrorActionPreference = 'Stop'

$url64      = ''
$checksum64 = ''

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
