$ErrorActionPreference = 'Stop'

$packageName  = $env:ChocolateyPackageName
$softwareName = 'Termius*'

[array]$key = Get-UninstallRegistryKey -SoftwareName $softwareName

if ($key.Count -eq 1) {
  # "<dir>\Uninstall Termius.exe" /currentuser - the path has a space, so split on the closing quote
  if ($key[0].UninstallString -notmatch '^"(?<file>[^"]+)"\s*(?<arguments>.*)$') {
    throw "Unrecognized uninstall entry: $($key[0].UninstallString)"
  }
  $file = $Matches.file
  $uninstallArgs = "$($Matches.arguments) /S".Trim()

  Get-Process -Name 'Termius' -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

  Uninstall-ChocolateyPackage -PackageName $packageName `
                              -FileType 'exe' `
                              -SilentArgs $uninstallArgs `
                              -File $file `
                              -ValidExitCodes @(0)

  # The NSIS uninstaller hands off to a copy in TEMP and returns at once, so wait for it to really finish
  $deadline = (Get-Date).AddSeconds(120)
  while ((Test-Path $file) -and (Get-Date) -lt $deadline) { Start-Sleep -Seconds 2 }
  if (Test-Path $file) { Write-Warning 'The Termius uninstaller had not finished after 2 minutes.' }
} elseif ($key.Count -eq 0) {
  Write-Warning "$packageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
  Write-Warning "$($key.Count) matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert the package maintainer that the following keys were matched:"
  $key | ForEach-Object { Write-Warning "- $($_.DisplayName)" }
}
