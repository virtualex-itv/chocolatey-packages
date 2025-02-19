$ErrorActionPreference  = 'Stop'

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://downloads.k8slens.dev/ide/Lens%20Setup%202025.2.141554-latest.exe'
$checksum               = 'f56e116f87b6aa9483f54d04c492d52f77a7c2adfeaa06c6a7b853a650055973'
$checksumType           = 'sha256'
$pp                     = Get-PackageParameters

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  softwareName          = 'Lens*'
  url                   = $url
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = '/allusers /disableAutoUpdates /S'
  validExitCodes        = @(0, 3010, 1605, 1614, 1641)
}

if ( $pp.CURRENTUSER) {
  $packageArgs['silentArgs'] = '/currentuser /disableAutoUpdates /S'
}

Install-ChocolateyPackage @packageArgs
