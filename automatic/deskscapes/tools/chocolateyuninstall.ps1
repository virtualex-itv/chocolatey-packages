$ErrorActionPreference = 'Stop'

$softwareName = 'Stardock DeskScapes*'

# Stardock's uninstaller for this product waits for input even when started silently (/s /noreboot), so it cannot run unattended
[array]$key = Get-UninstallRegistryKey -SoftwareName $softwareName

if ($key.Count -gt 0) {
  $key | ForEach-Object {
    Write-Warning "$($_.DisplayName) was NOT removed: Stardock's uninstaller waits for input even when started silently (/s /noreboot)."
  }
  Write-Warning 'Remove it from Settings > Apps > Installed apps (or Control Panel > Programs and Features).'
}
