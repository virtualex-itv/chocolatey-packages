$ErrorActionPreference = 'Stop';
Import-Module "$env:ChocolateyInstall\helpers\chocolateyInstaller.psm1"

$softwareName = 'TechSmith Capture'

[array]$key = Get-UninstallRegistryKey -softwareName "$($softwareName)"

& cmd /c $key.QuietUninstallString
