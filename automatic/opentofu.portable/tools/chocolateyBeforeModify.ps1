$ErrorActionPreference = 'Stop'

# A running tofu binary locks its file, so an upgrade or reinstall could not replace or remove the old folder.
$toolsDir = Split-Path $MyInvocation.MyCommand.Definition
Get-Process -Name 'tofu' -ErrorAction SilentlyContinue |
  Where-Object { $_.Path -and $_.Path.StartsWith($toolsDir + '\', [StringComparison]::OrdinalIgnoreCase) } |
  Stop-Process -Force
