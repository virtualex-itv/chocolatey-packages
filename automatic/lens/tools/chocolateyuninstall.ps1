$ErrorActionPreference = 'Stop'
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'Lens*'
  fileType      = 'exe'
  silentArgs    = '/currentuser /S'
  validExitCodes= @(0, 3010, 1605, 1614, 1641)
}

$uninstalled = $false
[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

if ($key.Count -eq 1) {
  $key | ForEach-Object { 
    $packageArgs['file'] = if ($_.UninstallString -match '^"(?<exe>[^"]+)"') { $Matches['exe'] } else { "$($_.UninstallString)" }
    $scope = ($_.UninstallString -replace '^"[^"]+"\s*', '').Trim()
    $packageArgs['silentArgs'] = "$scope /S".Trim()
    if ($packageArgs['fileType'] -eq 'MSI') {
      $packageArgs['silentArgs'] = "$($_.PSChildName) $($packageArgs['silentArgs'])"
      
      $packageArgs['file'] = ''
    }

    Uninstall-ChocolateyPackage @packageArgs

    # The NSIS uninstaller copies itself to TEMP and returns at once, so wait until Lens is really gone and fail loudly if it is not
    $deadline = (Get-Date).AddMinutes(2)
    while ((Get-Date) -lt $deadline -and (Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName'] -WarningAction SilentlyContinue)) { Start-Sleep -Seconds 2 }
    if (Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName'] -WarningAction SilentlyContinue) {
      throw "Lens is still installed 2 minutes after its uninstaller ran."
    }
  }
} elseif ($key.Count -eq 0) {
  Write-Warning "$packageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
  Write-Warning "$($key.Count) matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $key | ForEach-Object {Write-Warning "- $($_.DisplayName)"}
}
