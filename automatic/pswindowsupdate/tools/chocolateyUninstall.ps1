$ErrorActionPreference = 'Stop'

$moduleName = 'PSWindowsUpdate'  # this may be different from the package name and different case

Get-InstalledModule -Name $moduleName | Uninstall-Module -AllVersions -Force -ErrorAction "SilentlyContinue" -Verbose
