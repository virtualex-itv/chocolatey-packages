$ErrorActionPreference = 'Stop'

# bandwhich is a portable zip package with no uninstall entry; Chocolatey removes the files itself.
# bandwhich.exe must not be running or its folder cannot be deleted.
Get-Process -Name 'bandwhich' -ErrorAction SilentlyContinue | Stop-Process -Force