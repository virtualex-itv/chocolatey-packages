$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = ''
$checksum               = ''
$checksumType           = ''

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  softwareName          = "Stardock Curtains*"
  url                   = $url
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = '/s'
  validExitCodes        = @(0)
}

[version]$OSVer = (Get-WmiObject Win32_OperatingSystem).Version
$min='10.0.10240' #Windows 10 Threshold
$max='10.0.20348' #Windows Server 2022 21H2

If ( ( $OSVer -lt [version]$min ) -or ( $OSVer -ge [version]$max) ) {
  Write-Warning "*** Stardock $($packageName.substring(0,1).toupper()+$packageName.substring(1).tolower()) requires an OS running Windows 10 or higher, but/or is not compatible with $((Get-WmiObject Win32_OperatingSystem).Caption)... ***`n"
  throw
} Else {
  Install-ChocolateyPackage @packageArgs
}
