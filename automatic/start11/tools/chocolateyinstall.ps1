﻿$ErrorActionPreference  = 'Stop'

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://cdn.stardock.us/downloads/public/software/start/v2/Start11v2-setup.exe'
$checksum               = '6818e6ab406f1bea1fa40aaa512034540e8cf47c36e9741d7e01e61bb8afdc40'
$checksumType           = 'sha256'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  softwareName          = "Stardock Start11*"
  url                   = $url
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = '/s'
  validExitCodes        = @(0, 9)
}

[version]$OSVer = (Get-WmiObject Win32_OperatingSystem).Version
$min='10.0.10240'

If ( $OSVer -lt [version]$min ) {
  Write-Warning "*** Stardock $($packageName.substring(0,1).toupper()+$packageName.substring(1).tolower()) requires an OS running Windows 10 or 11... ***`n"
  throw
}

If (Test-Path ${env:ProgramFiles(x86)}"\Stardock\Start10\") {
  Write-Warning "*** Stardock Start10 was found and will be uninstalled automagically before installation. ***`n"
}

Install-ChocolateyPackage @packageArgs
