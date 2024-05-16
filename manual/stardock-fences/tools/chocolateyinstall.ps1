$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://cdn.stardock.us/downloads/public/software/fences/v5/Fences5-sd-setup.exe'
$checksum               = 'e137e6bb3f096c35582647d7d2f43d28f1c890f5adf8d6edb4ebeb56be43ebec'
$checksumType           = 'sha256'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  softwareName          = "Stardock Fences*"
  url                   = $url
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = '/s'
  validExitCodes        = @(0)
}


[version]$OSVer = (Get-WmiObject Win32_OperatingSystem).Version
$min='10.0.10240'

If ( $OSVer -lt [version]$min ) {
  Write-Warning "*** This version of Stardock $($packageName.substring(0,1).toupper()+$packageName.substring(1).tolower()) requires an OS running Windows 10 or higher... ***`n"
  throw
} Else {
  Install-ChocolateyPackage @packageArgs
}
