$ErrorActionPreference = 'Stop'

$moduleName   = 'VMware.WorkloadManagement'

Get-InstalledModule -Name $moduleName |  Uninstall-Module -AllVersions -Force -ErrorAction "SilentlyContinue"
