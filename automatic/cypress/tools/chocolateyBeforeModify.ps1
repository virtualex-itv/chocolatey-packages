$ErrorActionPreference = 'Stop'

# The app lives outside the package folder, so Chocolatey will not remove it; a running Cypress locks its files.
$installDir = Join-Path (Get-ToolsLocation) 'Cypress'
if (-not (Test-Path $installDir)) { return }

Get-Process -ErrorAction SilentlyContinue |
  Where-Object { $_.Path -and $_.Path.StartsWith($installDir + '\', [StringComparison]::OrdinalIgnoreCase) } |
  Stop-Process -Force -PassThru |
  Wait-Process -Timeout 15 -ErrorAction SilentlyContinue

Remove-Item $installDir -Recurse -Force
