$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://cdn.stardock.us/downloads/public/software/deskscapes/DeskScapes11-sd-setup.exe'
$checksum               = '229E72F833F093CD31A38D8661768621F6AFC8E306833142AACB6BEA88CD9D34'
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
