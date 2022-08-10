$ErrorActionPreference = 'Stop';

$softwareName = 'TechSmith Capture'

[array]$key = Get-UninstallRegistryKey -softwareName "$($softwareName)"

& cmd /c $key.QuietUninstallString
