$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'F3D*'
  fileType       = 'exe'
  silentArgs     = '/S'
  validExitCodes = @(0)
}

# The uninstaller cannot remove files that are in use.
Get-Process -Name 'f3d', 'f3d-console' -ErrorAction SilentlyContinue | Stop-Process -Force

Uninstall-BinFile -Name 'f3d'
Uninstall-BinFile -Name 'f3d-console'

[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

if ($key.Count -eq 1) {
  $packageArgs['file'] = "$($key[0].UninstallString -replace '"', '')"
  Uninstall-ChocolateyPackage @packageArgs
} elseif ($key.Count -eq 0) {
  Write-Warning "$($packageArgs['packageName']) has already been uninstalled by other means."
} else {
  Write-Warning "$($key.Count) matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $key | ForEach-Object { Write-Warning "- $($_.DisplayName)" }
}