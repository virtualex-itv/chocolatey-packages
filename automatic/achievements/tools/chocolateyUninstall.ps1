$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'Achievements*'
  fileType       = 'exe'
  validExitCodes = @(0)
}

# The uninstaller cannot remove files that are in use. Stop the app and its helpers, which run from the install folder.
$installPrefix = (Join-Path $env:ProgramFiles 'Achievements') + '\'
Get-Process -ErrorAction SilentlyContinue |
  Where-Object { $_.Path -and $_.Path.StartsWith($installPrefix, [StringComparison]::OrdinalIgnoreCase) } |
  Stop-Process -Force

[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

if ($key.Count -eq 1) {
  # The uninstall string carries a scope switch ('"<path>\Uninstall Achievements.exe" /allusers'): keep it, add /S.
  $uninstallString = $key[0].UninstallString
  $packageArgs['file'] = [regex]::Match($uninstallString, '^"([^"]+)"').Groups[1].Value
  $scopeArgs = $uninstallString.Substring($uninstallString.LastIndexOf('"') + 1).Trim()
  $packageArgs['silentArgs'] = "$scopeArgs /S".Trim()
  Uninstall-ChocolateyPackage @packageArgs

  # The uninstaller copies itself to TEMP and returns at once, so wait for the real removal.
  $installDir = Split-Path -Parent $packageArgs['file']
  for ($i = 0; $i -lt 60 -and (Test-Path -LiteralPath $packageArgs['file']); $i++) { Start-Sleep -Seconds 2 }
  if (Test-Path -LiteralPath $packageArgs['file']) { throw "Achievements was not removed from $installDir." }
} elseif ($key.Count -eq 0) {
  Write-Warning "$($packageArgs['packageName']) has already been uninstalled by other means."
} else {
  Write-Warning "$($key.Count) matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $key | ForEach-Object { Write-Warning "- $($_.DisplayName)" }
}
