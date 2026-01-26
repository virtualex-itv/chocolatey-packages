$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://cdn.stardock.us/downloads/public/software/cursorfx/CursorFX_setup_sd.exe'
$checksum               = '2297fff6268a1566955c1892e69437a1ecf92dec28d54c6e6acef15d0cfcae0d'
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

[version]$OSVer = (Get-WmiObject Win32_OperatingSystem).Version
$min='6.1.7601'

If ( $OSVer -lt [version]$min ) {
  Write-Warning "*** Stardock CursorFX requires an OS running Windows 7 or higher... ***`n"
  throw
} Else {
  Install-ChocolateyPackage @packageArgs
}
