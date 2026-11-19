$ErrorActionPreference = 'Stop'

# OpenTofu is a portable zip package with no uninstall entry; Chocolatey removes the files and the shim itself.
# No tofu binary may be running from the package folder or it cannot be deleted.
$toolsDir = Split-Path $MyInvocation.MyCommand.Definition
Get-Process -Name 'tofu' -ErrorAction SilentlyContinue |
  Where-Object { $_.Path -and $_.Path.StartsWith($toolsDir + '\', [StringComparison]::OrdinalIgnoreCase) } |
  Stop-Process -Force
