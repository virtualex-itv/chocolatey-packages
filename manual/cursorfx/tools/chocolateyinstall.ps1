$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://cdn.stardock.us/downloads/public/software/cursorfx/CursorFX4_4.03_setup_sd.exe'
$checksum               = '0198e05d4b4af04f82aef95e0c2d581ee4de15a454214ba200396be8d50581b5'
$checksumType           = 'sha256'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  softwareName          = "Stardock CursorFX*"
  url                   = $url
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = '/s'
  validExitCodes        = @(0)
}

$OSInfo = (Get-WmiObject Win32_OperatingSystem).ProductType
[version]$OSVer = (Get-WmiObject Win32_OperatingSystem).Version
$min='6.1.7601'

If ( $OSVer -lt [version]$min ) {
  Write-Warning "*** Stardock CursorFX requires an OS running Windows 7 or higher... ***`n"
  throw
} Else {
  Install-ChocolateyPackage @packageArgs
}
