$ErrorActionPreference = 'Stop'

$packageName  = $env:ChocolateyPackageName
$softwareName = 'Stardock Multiplicity*'

[array]$key = Get-UninstallRegistryKey -SoftwareName $softwareName

if ($key.Count -eq 1) {
  # Stardock uninstaller: "<dir>\uninstall.exe" "/U:<dir>\Uninstall\uninstall.xml"; Stardock documents /s /noreboot for a silent uninstall
  if ($key[0].UninstallString -notmatch '^"(?<file>[^"]+)"\s*(?<arguments>.*)$') {
    throw "Unrecognized uninstall entry: $($key[0].UninstallString)"
  }
  $file = $Matches.file
  $uninstallArgs = "$($Matches.arguments) /s /noreboot".Trim()

  # Close the app (the uninstaller cannot remove files in use) but keep SdAppServices: the uninstaller needs it
  $installDir = Split-Path $file
  Get-Process | Where-Object { $_.Path -like "$installDir\*" -and $_.Name -notlike 'SdAppServices*' } | Stop-Process -Force -ErrorAction SilentlyContinue

  Uninstall-ChocolateyPackage -PackageName $packageName `
                              -FileType 'exe' `
                              -SilentArgs $uninstallArgs `
                              -File $file `
                              -ValidExitCodes @(0, 3010, 1605, 1614, 1641)

  # Wait for the uninstaller to finish removing its entry
  $deadline = (Get-Date).AddSeconds(120)
  while ((Get-UninstallRegistryKey -SoftwareName $softwareName 3>$null) -and (Get-Date) -lt $deadline) { Start-Sleep -Seconds 2 }
  if (Get-UninstallRegistryKey -SoftwareName $softwareName 3>$null) { Write-Warning "$softwareName is still registered after 2 minutes; a reboot may be needed to finish the uninstall." }
} elseif ($key.Count -eq 0) {
  Write-Warning "$packageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
  Write-Warning "$($key.Count) matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert the package maintainer that the following keys were matched:"
  $key | ForEach-Object { Write-Warning "- $($_.DisplayName)" }
}
