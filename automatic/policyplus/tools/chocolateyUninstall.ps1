$ErrorActionPreference = 'Stop'

# Policy Plus is a portable exe with no uninstall entry; Chocolatey removes the files itself.
# PolicyPlus.exe must not be running or its folder cannot be deleted.
Get-Process -Name 'PolicyPlus' -ErrorAction SilentlyContinue | Stop-Process -Force

$shortcut = Join-Path ([Environment]::GetFolderPath('CommonPrograms')) 'Policy Plus.lnk'
Remove-Item $shortcut -Force -ErrorAction SilentlyContinue