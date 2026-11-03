$ErrorActionPreference = 'Stop'

# Mole is a portable zip package with no uninstall entry; Chocolatey removes the files and the mo shim itself.
# No Mole binary may be running from the package folder or it cannot be deleted.
$toolsDir = Split-Path $MyInvocation.MyCommand.Definition
Get-Process -Name 'mo', 'analyze', 'status' -ErrorAction SilentlyContinue |
  Where-Object { $_.Path -and $_.Path.StartsWith($toolsDir + '\', [StringComparison]::OrdinalIgnoreCase) } |
  Stop-Process -Force

Uninstall-BinFile -Name 'mole'
