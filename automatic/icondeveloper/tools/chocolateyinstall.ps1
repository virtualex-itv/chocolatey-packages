$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://cdn.stardock.us/downloads/public/software/icondeveloper/IconDeveloper_setup_sd.exe'
$checksum               = '4D477F194F63243D18FDEBC82A625D9D6BBC39F65B9A53E356F87F070C66A6DF'
$checksumType           = 'sha256'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  softwareName          = "Stardock IconDeveloper*"
  url                   = $url
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = '/s'
  validExitCodes        = @(0)
}

$OSProdType = (Get-WmiObject Win32_OperatingSystem).ProductType
[version]$OSVer = (Get-WmiObject Win32_OperatingSystem).Version
$min='6.1.7601'
$mid='6.2.9200'
$max='10.0.19045'

If ( $OSProdType -ne 1 ) {
  Write-Warning "*** Stardock IconDeveloper requires a desktop OS running Windows 7/8.1/10... ***`n"
  throw
}

If (( $OSVer -lt [version]$min ) -or ( $OSVer -eq [version]$mid ) -or ( $OSVer -gt [version]$max )) {
  Write-Warning "*** Stardock IconDeveloper requires a desktop OS running Windows 7/8.1/10... ***`n"
  throw
} Else {
  Install-ChocolateyPackage @packageArgs
}
