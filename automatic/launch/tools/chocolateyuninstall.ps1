$ErrorActionPreference = 'Stop'

$softwareName = 'Stardock Launch*'

# Stardock's uninstaller for this product restarts Windows without asking, even with /noreboot, so it cannot run unattended
[array]$key = Get-UninstallRegistryKey -SoftwareName $softwareName

if ($key.Count -gt 0) {
  $key | ForEach-Object {
    Write-Warning "$($_.DisplayName) was NOT removed: Stardock's uninstaller restarts Windows without asking, even with /noreboot."
  }
  Write-Warning 'Remove it from Settings > Apps > Installed apps (or Control Panel > Programs and Features).'
}
