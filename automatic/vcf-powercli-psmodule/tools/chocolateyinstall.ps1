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

# Windows PowerShell setup - skip entirely when /V7 is used.
# pwsh does its own setup later and Windows PowerShell isn't needed for the install path.
if (-not $usePwsh) {
  $Provider = Get-PackageProvider -ListAvailable -ErrorAction SilentlyContinue
  if ( $Provider.Name -notmatch "NuGet" ) {
    Install-PackageProvider -Name NuGet -Confirm:$false -Force
  }
  if (-not (Get-PSRepository -Name PSGallery -ErrorAction SilentlyContinue)) {
    Register-PSRepository -Default
  }
  Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

  if ( Get-Module -ListAvailable -Name "PowerShellGet" -ErrorAction SilentlyContinue ) {
    Install-Module -Name "PowerShellGet" -AllowClobber -Force
  }

  if ( Get-Module -ListAvailable -Name $moduleOldName -ErrorAction SilentlyContinue ) {
    Write-Host "  ** Removing legacy $moduleOldName, please be patient... **" -ForegroundColor Yellow
    Remove-Item "$ENV:ProgramData\Microsoft\Windows\Start Menu\Programs\$shortcutOldName" -Force -ErrorAction SilentlyContinue
    Remove-Item "$ENV:Public\Desktop\$shortcutOldName" -Force -ErrorAction SilentlyContinue
    Get-InstalledModule -Name "VMware.*" -ErrorAction SilentlyContinue | Uninstall-Module -AllVersions -Force -ErrorAction SilentlyContinue
  }

  if ( Get-Module -ListAvailable -Name $moduleName -ErrorAction SilentlyContinue ) {
    Write-Host "  ** Removing installed version, please be patient... **" -ForegroundColor Yellow
    Remove-Item "$ENV:ProgramData\Microsoft\Windows\Start Menu\Programs\$shortcutName" -Force -ErrorAction SilentlyContinue
    Remove-Item "$ENV:Public\Desktop\$shortcutName" -Force -ErrorAction SilentlyContinue
    Get-InstalledModule -Name "VCF.*" -ErrorAction SilentlyContinue | Uninstall-Module -AllVersions -Force -ErrorAction SilentlyContinue
    Get-InstalledModule -Name "VMware.*" -ErrorAction SilentlyContinue | Uninstall-Module -AllVersions -Force -ErrorAction SilentlyContinue
  }
}

# Will fail if package version is a revised version not matching the module version, i.e. x.x.x.0020180101
Write-Host "`n  ** Installing $moduleName v$moduleVers... **`n" -ForegroundColor Yellow

$scope = if ($pp.ALLUSERS) { 'AllUsers' } else { 'CurrentUser' }

if ($usePwsh) {
  # All PSGallery + NuGet provider setup happens inside pwsh - Windows PowerShell may have a broken module path
  $pwshSetup = @"
if (-not (Get-PSRepository -Name PSGallery -ErrorAction SilentlyContinue)) { Register-PSRepository -Default }
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Get-PackageProvider -Name NuGet -ForceBootstrap -Force | Out-Null
Install-Module -Name '$moduleName' -Scope $scope -RequiredVersion '$moduleVers' -AllowClobber -Force -SkipPublisherCheck
"@
  & $pwshExe -NoProfile -Command $pwshSetup
  if ($LASTEXITCODE -ne 0) { throw "PowerShell 7 install of $moduleName failed with exit code $LASTEXITCODE" }
} else {
  Get-PackageProvider -Name NuGet -Force | Out-Null
  Install-Module -Name $moduleName -Scope $scope -RequiredVersion $moduleVers -AllowClobber -Force -SkipPublisherCheck
}

if ( Get-Module -ListAvailable -Name $moduleName -ErrorAction SilentlyContinue ) {
  Install-ChocolateyShortcut -shortcutFilePath "$ENV:Public\Desktop\$shortcutName" -targetPath $exe -Arguments '-noe -c "Import-Module VCF.PowerCLI"' -WorkingDirectory "$ENV:SystemDrive\" -Description 'VCF.PowerCLI' -IconLocation "$toolsDir\powercli.ico" -RunAsAdmin
  Install-ChocolateyShortcut -shortcutFilePath "$ENV:ProgramData\Microsoft\Windows\Start Menu\Programs\$shortcutName" -targetPath $exe -Arguments '-noe -c "Import-Module VCF.PowerCLI"' -WorkingDirectory "$ENV:SystemDrive\" -Description 'VCF.PowerCLI' -IconLocation "$toolsDir\powercli.ico" -RunAsAdmin
}
