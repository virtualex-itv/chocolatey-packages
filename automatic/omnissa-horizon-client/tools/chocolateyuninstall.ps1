$ErrorActionPreference = 'Stop';
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'Omnissa Horizon Client*'
  fileType      = 'EXE'
  silentArgs    = '/uninstall /quiet /norestart'
  validExitCodes= @(0, 3010, 1614, 1641)
}

$uninstalled = $false
[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName'] | Where-Object { -not $_.WindowsInstaller }

if ($key.Count -eq 1) {
  $key | ForEach-Object {
    $packageArgs['file'] = if ($_.UninstallString -match '^"(?<exe>[^"]+)"') { $Matches['exe'] } else { "$($_.UninstallString)" }

    Uninstall-ChocolateyPackage @packageArgs
  }
} elseif ($key.Count -eq 0) {
  Write-Warning "$packageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
  Write-Warning "$($key.Count) matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $key | ForEach-Object {Write-Warning "- $($_.DisplayName)"}
}
