$ErrorActionPreference = 'Stop'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'observIQ Distro for OpenTelemetry Collector*'
  fileType       = 'msi'
  silentArgs     = '/qn /norestart'
  validExitCodes = @(0, 3010, 1605, 1614, 1641)
}

# The MSI also writes a second key named after the product (repair only), so keep the one named by product code.
[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName'] |
  Where-Object { $_.PSChildName -match '^\{[0-9A-Fa-f-]{36}\}$' }

if ($key.Count -eq 1) {
  # The MSI stops and removes the observiq-otel-collector service itself.
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
