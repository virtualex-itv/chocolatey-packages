$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'Paragon Partition Manager*'
  fileType       = 'exe'
  silentArgs     = '/uninstall /quiet /norestart'
  validExitCodes = @(0, 3010)
}

# The uninstaller cannot remove files that are in use.
$installDir = Join-Path $env:ProgramFiles 'Paragon Software'
Get-Process -ErrorAction SilentlyContinue |
  Where-Object { $_.Path -and $_.Path.StartsWith("$installDir\", [StringComparison]::OrdinalIgnoreCase) } |
  Stop-Process -Force

# The installer registers two entries: the Burn bundle (has a QuietUninstallString) and the MSI inside it.
# Uninstalling the bundle removes both.
[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName'] | Where-Object { $_.QuietUninstallString }

if ($key.Count -eq 1) {
  $packageArgs['file'] = [regex]::Match($key[0].QuietUninstallString, '^"([^"]+)"').Groups[1].Value
  Uninstall-ChocolateyPackage @packageArgs
} elseif ($key.Count -eq 0) {
  Write-Warning "$($packageArgs['packageName']) has already been uninstalled by other means."
} else {
  Write-Warning "$($key.Count) matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $key | ForEach-Object { Write-Warning "- $($_.DisplayName)" }
}
