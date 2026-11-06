$ErrorActionPreference = 'Stop'

[array]$key = Get-UninstallRegistryKey -SoftwareName 'Logitech G HUB*'

if ($key.Count -eq 0) {
  Write-Warning 'Logitech G HUB is not installed (no uninstall registry entry found); nothing to remove.'
  return
}
if ($key.Count -gt 1) {
  throw "$($key.Count) uninstall entries match 'Logitech G HUB*'; refusing to guess which one to remove."
}

# UninstallString is the quoted or bare path of the G HUB program in its install folder
$installDir = Split-Path -Parent ($key[0].UninstallString -replace '^"(.*?)".*$', '$1')
$uninstaller = Join-Path $installDir 'lghub_updater.exe'
if (-not (Test-Path $uninstaller)) {
  throw "Could not find the G HUB uninstaller at $uninstaller"
}

# --full clears the updater's state (plain --uninstall left some that made the next install hang), --keep-user-data keeps settings and profiles.
# The updater service host is the uninstaller itself, so it is not stopped here.
Uninstall-ChocolateyPackage -PackageName $env:ChocolateyPackageName `
  -FileType 'exe' `
  -SilentArgs '--uninstall --full --keep-user-data' `
  -ValidExitCodes @(0) `
  -File $uninstaller

# The uninstaller may return before it has finished, so wait for the registry entry to go
$deadline = (Get-Date).AddMinutes(3)
while ((Get-Date) -lt $deadline -and (Get-UninstallRegistryKey -SoftwareName 'Logitech G HUB*' -WarningAction SilentlyContinue)) {
  Start-Sleep -Seconds 3
}
if (Get-UninstallRegistryKey -SoftwareName 'Logitech G HUB*' -WarningAction SilentlyContinue) {
  throw 'Logitech G HUB is still registered after the uninstaller ran.'
}
