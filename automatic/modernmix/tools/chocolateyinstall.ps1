$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = ''
$checksum               = ''
$checksumType           = ''

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  softwareName          = "Stardock ModernMix*"
  url                   = $url
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = '/s'
  validExitCodes        = @(0)
}

[version]$OSVer = (Get-WmiObject Win32_OperatingSystem).Version
$min='6.2.9200'
$max='6.3.9600'

If ( ( $OSVer -lt [version]$min ) -or ( $OSVer -gt [version]$max ) ) {
  Write-Warning "*** Stardock ModernMix requires an OS running Windows 8/8.1 or Windows Server 2012/R2... ***`n"
  throw
} Else {
  Install-ChocolateyPackage @packageArgs
}
