$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://cdn.stardock.us/downloads/public/software/start/Start8_setup_sd.exe'
$checksum               = 'a8385a71a8b5c5f7f011fb0e4d0d0b273d9a1ea25e6188a66e1e1f0c551d78c1'
$checksumType           = 'sha256'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  softwareName          = "Stardock Start8*"
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
  Write-Warning "*** Stardock $($packageName.substring(0,1).toupper()+$packageName.substring(1).tolower()) requires an OS running Windows 8/8.1 or Windows Server 2012/2012 R2... ***`n"
  throw
} Else {
  Install-ChocolateyPackage @packageArgs
}
