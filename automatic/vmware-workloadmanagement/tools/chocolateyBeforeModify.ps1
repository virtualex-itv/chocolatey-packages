$ErrorActionPreference = 'Stop'

$moduleName = 'VMware.WorkloadManagement'     # this could be different from package name
Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue
