$ErrorActionPreference = 'Stop';

$softwareName = 'Logi Options+'

[array]$key = Get-UninstallRegistryKey -softwareName "$($softwareName)"

& cmd /c $key.QuietUninstallString
