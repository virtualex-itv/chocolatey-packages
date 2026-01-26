$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://cdn.stardock.us/downloads/public/software/soundpackager/SoundPackager10_setup_sd.exe'
$checksum               = '5d17fa73b3397b9af04c296535b6d39d8a23fd8d02c6bc90117e0ca521e66993'
$checksumType           = 'sha256'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  softwareName          = "Stardock SoundPackager*"
  url                   = $url
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = '/s'
  validExitCodes        = @(0)
}

[version]$OSVer = (Get-WmiObject Win32_OperatingSystem).Version
$min='6.1.7601'

If ( $OSVer -lt [version]$min ) {
  Write-Warning "*** Stardock SoundPackager requires a desktop OS running Windows 7 or higher... ***`n"
  throw
} Else {
  Install-ChocolateyPackage @packageArgs
}
