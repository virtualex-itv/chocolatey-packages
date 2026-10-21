$ErrorActionPreference = 'Stop'

# gum is a portable zip package with no uninstall entry; Chocolatey removes the files itself.
# gum.exe must not be running or its folder cannot be deleted.
Get-Process -Name 'gum' -ErrorAction SilentlyContinue | Stop-Process -Force
