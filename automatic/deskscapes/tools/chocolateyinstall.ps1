$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://stardock.cachefly.net/software/DeskScapes/DeskScapes2026/DeskScapes2026_setup.exe'
$checksum               = 'dcd31ccda536ab66b1b1212faeeccde14dad99bec23ca0d2a8f25d82bd08ff30'
$checksumType           = 'sha256'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  softwareName          = "Stardock DeskScapes*"
  url                   = $url
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = '/s'
  validExitCodes        = @(0)
}

[version]$OSVer = (Get-WmiObject Win32_OperatingSystem).Version
$min='10.0.10240'

If ( $OSVer -lt [version]$min ) {
  Write-Warning "*** Stardock DeskScapes 11 requires an OS running Windows 10 or higher... ***`n"
  throw
} Else {
  Install-ChocolateyPackage @packageArgs
}
