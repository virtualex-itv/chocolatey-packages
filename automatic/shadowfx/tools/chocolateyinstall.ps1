$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://cdn.stardock.us/downloads/public/software/shadowfx/ShadowFX_setup_sd.exe'
$checksum               = '020eac1851697d7e60dc84339ea10c0f2b63f3fbf9d79037e4d7ab82a1d59eb1'
$checksumType           = 'sha256'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  softwareName          = "Stardock ShadowFX*"
  url                   = $url
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = '/s'
  validExitCodes        = @(0)
}

[version]$OSVer = (Get-WmiObject Win32_OperatingSystem).Version
$min='6.2.9200'

If ( $OSVer -lt [version]$min ) {
  Write-Warning "*** Stardock ShadowFX requires an OS running Windows 8 oh higher... ***`n"
  throw
} Else {
  Install-ChocolateyPackage @packageArgs
}
