$ErrorActionPreference = 'Stop'

# age is a portable zip package with no uninstall entry; Chocolatey removes the files and shims itself.
# No age binary may be running from the package folder or it cannot be deleted.
$toolsDir = Split-Path $MyInvocation.MyCommand.Definition
Get-Process -Name 'age*' -ErrorAction SilentlyContinue |
  Where-Object { $_.Path -and $_.Path.StartsWith($toolsDir + '\', [StringComparison]::OrdinalIgnoreCase) } |
  Stop-Process -Force
