$ErrorActionPreference = 'Stop'

$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$pp           = Get-PackageParameters

$packageName  = $env:ChocolateyPackageName
$shortcutOldName = 'VMware.PowerCLI.lnk'
$shortcutName = 'VCF.PowerCLI.lnk'
$exe          = "$ENV:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"
$moduleOldName = 'VMware.PowerCLI'
$moduleName   = 'VCF.PowerCLI'
$moduleVers   = "$env:ChocolateyPackageVersion"

$usePwsh = $pp.V7

if ($usePwsh) {
  $pwshExe = "$ENV:ProgramFiles\PowerShell\7\pwsh.exe"
  if (-not (Test-Path $pwshExe)) {
    throw "PowerShell 7 not found at: $pwshExe. Install it first: choco install powershell-core"
  }
  Write-Host "  ** /V7 specified - installing $moduleName via PowerShell 7 **" -ForegroundColor Yellow
  $exe = $pwshExe
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

if ( Get-Module -ListAvailable -Name $moduleOldName -ErrorAction SilentlyContinue ) {
  Write-Host "  ** Removing legacy $moduleOldName, please be patient... **" -ForegroundColor Yellow
  Remove-Item "$ENV:ProgramData\Microsoft\Windows\Start Menu\Programs\$shortcutOldName" -Force -ErrorAction SilentlyContinue
  Remove-Item "$ENV:Public\Desktop\$shortcutOldName" -Force -ErrorAction SilentlyContinue
  Get-InstalledModule -Name "VMware.*" | Uninstall-Module -AllVersions -Force -ErrorAction SilentlyContinue
}

if ( Get-Module -ListAvailable -Name $moduleName -ErrorAction SilentlyContinue ) {
  Write-Host "  ** Removing installed version, please be patient... **" -ForegroundColor Yellow
  Remove-Item "$ENV:ProgramData\Microsoft\Windows\Start Menu\Programs\$shortcutName" -Force -ErrorAction SilentlyContinue
  Remove-Item "$ENV:Public\Desktop\$shortcutName" -Force -ErrorAction SilentlyContinue
  Get-InstalledModule -Name "VCF.*" | Uninstall-Module -AllVersions -Force -ErrorAction SilentlyContinue
  Get-InstalledModule -Name "VMware.*" | Uninstall-Module -AllVersions -Force -ErrorAction SilentlyContinue
}

# Will fail if package version is a revised version not matching the module version, i.e. x.x.x.0020180101
Write-Host "`n  ** Installing $moduleName v$moduleVers... **`n" -ForegroundColor Yellow
Get-PackageProvider -Name NuGet -Force

$scope = if ($pp.ALLUSERS) { 'AllUsers' } else { 'CurrentUser' }

if ($usePwsh) {
  & $pwshExe -NoProfile -Command "Install-Module -Name '$moduleName' -Scope $scope -RequiredVersion '$moduleVers' -AllowClobber -Force -SkipPublisherCheck"
} else {
  Install-Module -Name $moduleName -Scope $scope -RequiredVersion $moduleVers -AllowClobber -Force -SkipPublisherCheck
}

if ( Get-Module -ListAvailable -Name $moduleName -ErrorAction SilentlyContinue ) {
  Install-ChocolateyShortcut -shortcutFilePath "$ENV:Public\Desktop\$shortcutName" -targetPath $exe -Arguments '-noe -c "Import-Module VCF.PowerCLI"' -WorkingDirectory "$ENV:SystemDrive\" -Description 'VCF.PowerCLI' -IconLocation "$toolsDir\powercli.ico" -RunAsAdmin
  Install-ChocolateyShortcut -shortcutFilePath "$ENV:ProgramData\Microsoft\Windows\Start Menu\Programs\$shortcutName" -targetPath $exe -Arguments '-noe -c "Import-Module VCF.PowerCLI"' -WorkingDirectory "$ENV:SystemDrive\" -Description 'VCF.PowerCLI' -IconLocation "$toolsDir\powercli.ico" -RunAsAdmin
}
