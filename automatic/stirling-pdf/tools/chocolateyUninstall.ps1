$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'Stirling PDF*'
  fileType       = 'msi'
  silentArgs     = '/qn /norestart'
  validExitCodes = @(0, 3010, 1605, 1614, 1641)
}

# The uninstaller cannot remove files that are in use. Stop whatever runs from the install folder
# (the app and its bundled Java backend), not by a guessed process name.
$installPrefix = (Join-Path $env:ProgramFiles 'Stirling PDF') + '\'
Get-Process -ErrorAction SilentlyContinue |
  Where-Object { $_.Path -and $_.Path.StartsWith($installPrefix, [StringComparison]::OrdinalIgnoreCase) } |
  Stop-Process -Force

[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

if ($key.Count -eq 1) {
  $packageArgs['silentArgs'] = "$($key[0].PSChildName) $($packageArgs['silentArgs'])"
  $packageArgs['file'] = ''
  Uninstall-ChocolateyPackage @packageArgs
} elseif ($key.Count -eq 0) {
  Write-Warning "$($packageArgs['packageName']) has already been uninstalled by other means."
} else {
  Write-Warning "$($key.Count) matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $key | ForEach-Object { Write-Warning "- $($_.DisplayName)" }
}
