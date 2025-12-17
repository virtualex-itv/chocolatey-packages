$ErrorActionPreference = 'Stop'

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$pp           = Get-PackageParameters

$packageName  = $env:ChocolateyPackageName
$shortcutName = 'VMware.PowerCLI.lnk'
$exe          = "$ENV:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"
$moduleName   = 'VMware.PowerCLI'
$moduleVers   = "$env:ChocolateyPackageVersion"

$PSversion = $PSVersionTable.PSVersion.Major
if ($PSversion -lt "5") {
  Write-Warning "  ** PowerShell < v5 detected."
  Write-Warning "  ** $packageName installs via the PowerShell Gallery and thus requires PowerShell v5+."
  Write-Warning "  ** If PowerShell v5 was installed as a dependency, you need to reboot and reinstall this package."
  throw
}

$Provider = Get-PackageProvider -ListAvailable -ErrorAction SilentlyContinue
if ( $Provider.Name -notmatch "NuGet" ) { 
  Install-PackageProvider -Name NuGet -Confirm:$false -Force
  Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
} else {
  Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
}

if ( Get-Module -ListAvailable -Name "PowerShellGet" -ErrorAction SilentlyContinue ) {
  Install-Module -Name "PowerShellGet" -AllowClobber -Force
}

if ( Get-Module -ListAvailable -Name $moduleName -ErrorAction SilentlyContinue ) {
  Write-Host "  ** Removing installed version, please be patient... **" -ForegroundColor Yellow
  Remove-Item "$ENV:ProgramData\Microsoft\Windows\Start Menu\Programs\$shortcutName" -Force -ErrorAction SilentlyContinue
  Remove-Item "$ENV:Public\Desktop\$shortcutName" -Force -ErrorAction SilentlyContinue
  Get-InstalledModule -Name "VMware.*" | Uninstall-Module -AllVersions -Force -ErrorAction SilentlyContinue
}

# Will fail if package version is a revised version not matching the module version, i.e. x.x.x.0020180101
Write-Host "`n  ** Installing $moduleName v$moduleVers... **`n" -ForegroundColor Yellow
Get-PackageProvider -Name NuGet -Force

if ($pp.ALLUSERS) {
  Install-Module -Name $moduleName -Scope AllUsers -RequiredVersion $moduleVers -AllowClobber -Force
} else {
  Install-Module -Name $moduleName -Scope CurrentUser -RequiredVersion $moduleVers -AllowClobber -Force
}

if ( Get-Module -ListAvailable -Name $moduleName -ErrorAction SilentlyContinue ) {
  Install-ChocolateyShortcut -shortcutFilePath "$ENV:Public\Desktop\$shortcutName" -targetPath $exe -Arguments '-noe -c "Import-Module VMware.PowerCLI"' -WorkingDirectory "$ENV:SystemDrive\" -Description 'VMware.PowerCLI' -IconLocation "$toolsDir\powercli.ico" -RunAsAdmin
  Install-ChocolateyShortcut -shortcutFilePath "$ENV:ProgramData\Microsoft\Windows\Start Menu\Programs\$shortcutName" -targetPath $exe -Arguments '-noe -c "Import-Module VMware.PowerCLI"' -WorkingDirectory "$ENV:SystemDrive\" -Description 'VMware.PowerCLI' -IconLocation "$toolsDir\powercli.ico" -RunAsAdmin
}