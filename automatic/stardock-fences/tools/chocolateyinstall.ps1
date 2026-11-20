$ErrorActionPreference  = 'Stop'

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://stardock.cachefly.net/software/Fences/Fences7/Fences7_setup.exe'
$checksum               = '9ba0d298489dbe1df2ef54830428482dd8ff06af026c2a139f78db05af740f3d'
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
  validExitCodes        = @(0, 9)
}

[version]$OSVer = (Get-WmiObject Win32_OperatingSystem).Version
$min = '10.0.10240'

If ($OSVer -lt [version]$min) {
  Write-Warning "*** This version of Stardock Fences requires an OS running Windows 10 or higher... ***`n"
  throw
} Else {
  Install-ChocolateyPackage @packageArgs
}
