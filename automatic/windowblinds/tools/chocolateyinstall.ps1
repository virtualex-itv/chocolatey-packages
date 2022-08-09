$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://cdn.stardock.us/downloads/public/software/windowblinds/WindowBlinds10_setup_sd.exe'
$checksum               = 'c8f1f37c5fa19b5f1775a6938c1b9da950ea9081527d210d743494dc72334a4e'
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
$max='10.0.19045'

If (($OSVer -lt [version]$min) -or ($OSVer -gt [version]$max)) {
  Write-Warning "*** Stardock WindowBlinds requires a desktop OS running Windows 7 or higher but/or is not compatible with $((Get-WmiObject Win32_OperatingSystem).Caption) ***`n"
  throw
} Else {
  Install-ChocolateyPackage @packageArgs
}
