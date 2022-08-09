$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://cdn.stardock.us/downloads/public/software/launch/Launch-setup_sd.exe'
$checksum               = '67f9fc075f73f9b68fa081c505763295ffeaea9d29a1f48b66ed6cb12b49fe8e'
$checksumType           = 'sha256'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  softwareName          = "Stardock Launch*"
  url                   = $url
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = '/s'
  validExitCodes        = @(0)
}

[version]$OSVer = (Get-WmiObject Win32_OperatingSystem).Version
$min='6.2.9200'

If ( $OSVer -lt [version]$min ) {
  Write-Warning "*** Stardock Launch requires an OS running Windows 8 or higher... ***`n"
  throw
} Else {
  Install-ChocolateyPackage @packageArgs
}
