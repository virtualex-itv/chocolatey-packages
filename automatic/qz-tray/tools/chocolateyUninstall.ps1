$ErrorActionPreference = 'Stop'

[array]$key = Get-UninstallRegistryKey -SoftwareName 'QZ Tray*'

if ($key.Count -eq 1) {
  $uninstaller = $key[0].UninstallString.Trim('"')
  $installDir  = Split-Path $uninstaller

  # Stop QZ Tray and its bundled Java runtime so no file in the install folder is locked.
  Get-Process -ErrorAction SilentlyContinue |
    Where-Object { $_.Path -and $_.Path.StartsWith($installDir + '\', [StringComparison]::OrdinalIgnoreCase) } |
    Stop-Process -Force

  # The uninstaller copies itself to TEMP, starts that copy and exits at once (exit code 2), so wait for the real uninstall to finish.
  Uninstall-ChocolateyPackage -PackageName $env:ChocolateyPackageName -FileType 'exe' -SilentArgs '/S' -File $uninstaller -ValidExitCodes @(0, 2)

  $deadline = (Get-Date).AddMinutes(3)
  while (((Test-Path $key[0].PSPath) -or (Test-Path $installDir)) -and (Get-Date) -lt $deadline) { Start-Sleep -Seconds 2 }
  if (Test-Path $key[0].PSPath) { throw "QZ Tray uninstall did not finish within 3 minutes." }
} elseif ($key.Count -eq 0) {
  Write-Warning "$env:ChocolateyPackageName has already been uninstalled by other means."
} else {
  Write-Warning "$($key.Count) matches found. To prevent accidental data loss, no programs will be uninstalled."
  $key | ForEach-Object { Write-Warning "- $($_.DisplayName)" }
}
