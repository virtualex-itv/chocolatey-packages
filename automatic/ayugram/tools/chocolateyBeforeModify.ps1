$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path $MyInvocation.MyCommand.Definition

# Chocolatey removes the old files before an upgrade or uninstall, which fails while AyuGram or its updater runs from the tools folder.
$running = @(Get-Process -ErrorAction SilentlyContinue |
  Where-Object { $_.Path -and $_.Path.StartsWith("$toolsDir\", [StringComparison]::OrdinalIgnoreCase) })
$running | Stop-Process -Force
$running | ForEach-Object { $_.WaitForExit(15000) | Out-Null }

# AyuGram keeps its data (sign-in, settings, cache) in a tdata folder next to the exe, and an upgrade deletes the old
# folder. Keep a copy so the install script can put it back.
$data = Join-Path $toolsDir 'tdata'
$backup = Join-Path $env:ProgramData 'AyuGram-tdata-backup'
if (Test-Path $data) {
  if (Test-Path $backup) { Remove-Item $backup -Recurse -Force }
  Copy-Item $data $backup -Recurse -Force
}
