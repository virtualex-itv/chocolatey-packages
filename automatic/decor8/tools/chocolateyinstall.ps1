$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://cdn.stardock.us/downloads/public/software/decor8/Decor8_setup_sd.exe'
$checksum               = 'e6b923d75c14e07c3c69ee045277d2b2203ad9ca7a5b1e489e0d8e4dde210ed4'
$checksumType           = 'sha256'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  softwareName          = "Stardock Decor8*"
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
  Write-Warning "*** Stardock Decor8 requires an OS running Windows 8/8.1 or Windows Server 2012/R2... ***`n"
  throw
} Else {
  Install-ChocolateyPackage @packageArgs
}
