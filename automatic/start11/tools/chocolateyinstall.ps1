$ErrorActionPreference  = 'Stop'

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://cdn.stardock.us/downloads/public/software/start/Start11_Setup.exe'
$checksum               = '6e767e2bdecb8325aa6dd779de914707aa00d960c722159165946c227e9e102f'
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
