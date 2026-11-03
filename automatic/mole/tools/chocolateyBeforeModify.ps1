$ErrorActionPreference = 'Stop'

# A running mo, analyze or status binary locks its files, so an upgrade or reinstall could not replace the old folder.
$toolsDir = Split-Path $MyInvocation.MyCommand.Definition
Get-Process -Name 'mo', 'analyze', 'status' -ErrorAction SilentlyContinue |
  Where-Object { $_.Path -and $_.Path.StartsWith($toolsDir + '\', [StringComparison]::OrdinalIgnoreCase) } |
  Stop-Process -Force
