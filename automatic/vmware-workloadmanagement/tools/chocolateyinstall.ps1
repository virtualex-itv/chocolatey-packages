$ErrorActionPreference = 'Stop'

$moduleName   = 'VMware.WorkloadManagement'
$moduleVers   = "$env:ChocolateyPackageVersion"

if ( Get-InstalledModule -Name $moduleName -ErrorAction SilentlyContinue ){
  Write-Host "  ** Removing installed version(s), please be patient... **" -ForegroundColor Yellow
  Get-InstalledModule -Name $moduleName | Uninstall-Module -AllVersions -Force -ErrorAction "SilentlyContinue"
}

# Will fail if package version is a revised version not matching the module version, i.e. x.x.x.0020180101
Write-Host "`n  ** Installing $moduleName v$moduleVers... **`n" -ForegroundColor Yellow
Get-PackageProvider -Name NuGet -Force
Install-Module -Name $moduleName -Scope AllUsers -RequiredVersion $moduleVers -Force
