$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path $MyInvocation.MyCommand.Definition

# AyuGram is a portable zip package with no uninstall entry; Chocolatey removes the files itself.
# Nothing may run from the tools folder or it cannot be deleted.
Get-Process -ErrorAction SilentlyContinue |
  Where-Object { $_.Path -and $_.Path.StartsWith("$toolsDir\", [StringComparison]::OrdinalIgnoreCase) } |
  Stop-Process -Force

# Drop the temporary copy of tdata that chocolateyBeforeModify.ps1 makes for upgrades.
Remove-Item (Join-Path $env:ProgramData 'AyuGram-tdata-backup') -Recurse -Force -ErrorAction SilentlyContinue

$shortcut = Join-Path ([Environment]::GetFolderPath('CommonPrograms')) 'AyuGram.lnk'
Remove-Item $shortcut -Force -ErrorAction SilentlyContinue
