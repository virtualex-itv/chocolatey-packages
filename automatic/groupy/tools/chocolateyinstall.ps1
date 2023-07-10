$ErrorActionPreference  = 'Stop'

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = ''
$checksum               = ''
$checksumType           = ''

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  softwareName          = "Stardock Groupy*"
  url                   = $url
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = '/S'
  validExitCodes        = @(0, 9)
}

[version]$OSVer = (Get-WmiObject Win32_OperatingSystem).Version
$min='10.0.10240'

If ( $OSVer -lt [version]$min ) {
  Write-Warning "*** Stardock $($packageName.substring(0,1).toupper()+$packageName.substring(1).tolower()) requires an OS running Windows 10 or 11... ***`n"
  throw
}

If (Test-Path ${env:ProgramFiles(x86)}"\Stardock\Groupy\") {
  Write-Warning "*** Stardock Groupy was found and will be uninstalled automagically. ***`n"
}

Install-ChocolateyPackage @packageArgs
