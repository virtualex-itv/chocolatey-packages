$ErrorActionPreference = 'Stop'

$packageName  = $env:ChocolateyPackageName
$softwareName = 'Warp*'

[array]$key = Get-UninstallRegistryKey -SoftwareName $softwareName

if ($key.Count -eq 1) {
  # Inno Setup: "<dir>\unins000.exe"
  if ($key[0].UninstallString -notmatch '^"?(?<file>[^"]+\.exe)"?') {
    throw "Unrecognized uninstall entry: $($key[0].UninstallString)"
  }
  $file = $Matches.file

  $installDir = Split-Path $file
  Get-Process | Where-Object { $_.Path -like "$installDir\*" } | Stop-Process -Force -ErrorAction SilentlyContinue

  Uninstall-ChocolateyPackage -PackageName $packageName `
                              -FileType 'exe' `
                              -SilentArgs '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART' `
                              -File $file `
                              -ValidExitCodes @(0)

  # Inno's uninstaller hands off to a copy in TEMP and returns at once, so wait for it to really finish
  $deadline = (Get-Date).AddSeconds(120)
  while ((Test-Path $file) -and (Get-Date) -lt $deadline) { Start-Sleep -Seconds 2 }
  if (Test-Path $file) { Write-Warning 'The Warp uninstaller had not finished after 2 minutes.' }
} elseif ($key.Count -eq 0) {
  Write-Warning "$packageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
  Write-Warning "$($key.Count) matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert the package maintainer that the following keys were matched:"
  $key | ForEach-Object { Write-Warning "- $($_.DisplayName)" }
}
