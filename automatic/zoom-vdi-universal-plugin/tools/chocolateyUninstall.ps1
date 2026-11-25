$ErrorActionPreference = 'Stop'

[array]$key = Get-UninstallRegistryKey -SoftwareName 'Zoom VDI Universal Plugin*'

if ($key.Count -eq 1) {
  # Stop anything running from the plugin folder first so no file in the install folder is locked.
  if ($key[0].InstallLocation) {
    $installDir = $key[0].InstallLocation.TrimEnd('\')
    Get-Process -ErrorAction SilentlyContinue |
      Where-Object { $_.Path -and $_.Path.StartsWith($installDir + '\', [StringComparison]::OrdinalIgnoreCase) } |
      Stop-Process -Force
  }

  Uninstall-ChocolateyPackage -PackageName $env:ChocolateyPackageName -FileType 'msi' -SilentArgs "$($key[0].PSChildName) /qn /norestart" -File '' -ValidExitCodes @(0, 3010, 1605, 1614, 1641)
} elseif ($key.Count -eq 0) {
  Write-Warning "$env:ChocolateyPackageName has already been uninstalled by other means."
} else {
  Write-Warning "$($key.Count) matches found. To prevent accidental data loss, no programs will be uninstalled."
  $key | ForEach-Object { Write-Warning "- $($_.DisplayName)" }
}
