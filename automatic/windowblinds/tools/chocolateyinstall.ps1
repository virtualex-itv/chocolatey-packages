$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = ''
$checksum               = ''
$checksumType           = ''

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
