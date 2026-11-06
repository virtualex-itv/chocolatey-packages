$ErrorActionPreference = 'Stop'

$toolsDir              = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                   = 'https://download01.logi.com/web/ftp/pub/techsupport/gaming/lghub_installer.exe'
$checksum              = '883399CFC1D45A38BC70D584DC4349FE031CF2402F8B17DC78812B3BB674E06C'
$checksumType          = 'sha256'

# operating system check
$WindowsVersion=[Environment]::OSVersion.Version
if ($WindowsVersion.Major -ne "10") {
  throw "This package requires Windows 10 or Windows 11."
}

$pp = Get-PackageParameters

# The setup program exits without doing anything when G HUB is installed, so an installed G HUB updates through its own API
[array]$installed = Get-UninstallRegistryKey -SoftwareName 'Logitech G HUB*' -WarningAction SilentlyContinue
if ($installed.Count -gt 0) {
  if ($pp.Canary) { Write-Warning '/Canary applies to a fresh install only and is ignored. Uninstall G HUB first to switch to the canary channel.' }
  . (Join-Path $toolsDir 'helpers.ps1')
  Update-InstalledGHub -InstallDir (Split-Path -Parent ($installed[0].UninstallString -replace '^"(.*?)".*$', '$1'))
  return
}

$silentArgs = '--silent'
if ($pp.Canary) {
  $silentArgs += ' --channel=canary'
  Write-Warning 'Installing the G HUB canary (early access) build. Canary builds can be less stable, and this machine stays on the canary channel until G HUB is uninstalled.'
}

$packageArgs = @{
  packageName        = $env:ChocolateyPackageName
  unzipLocation      = $toolsDir
  fileType           = 'exe'
  softwareName       = "Logitech G HUB*"
  url                = $url
  checksum           = $checksum
  checksumType       = $checksumType
  silentArgs         = $silentArgs
  validExitCodes     = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
