$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://cdn.stardock.us/downloads/public/software/windowblinds/WindowBlinds11_setup.exe?a=sd'
$checksum               = 'e9e14d0750126ad016f3d31691b9878c0c9dc9e6246230f42554a55d22012a0b'
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
