$ErrorActionPreference = 'Stop'

$moduleName = 'PSWindowsUpdate'      # this could be different from package name

Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue
