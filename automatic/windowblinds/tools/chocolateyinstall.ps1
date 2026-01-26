$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://cdn.stardock.us/downloads/public/software/windowblinds/WindowBlinds11_setup.exe'
$checksum               = '15aea7ad9cc969e69130b1731de17c8f23e0871de3e52beddd70ae0ebc283dfd'
$checksumType           = 'sha256'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  softwareName          = "Stardock WindowBlinds*"
  url                   = $url
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = '/s'
  validExitCodes        = @(0)
}

[version]$OSVer = (Get-WmiObject Win32_OperatingSystem).Version
$min='6.1.7601'
#$max='10.0.19045'

#If (($OSVer -lt [version]$min) -or ($OSVer -gt [version]$max)) {
If ($OSVer -lt [version]$min) {
  Write-Warning "*** Stardock WindowBlinds requires an OS running Windows 7 or higher but/or is not compatible with $((Get-WmiObject Win32_OperatingSystem).Caption) ***`n"
  throw
} Else {
  Install-ChocolateyPackage @packageArgs
}
