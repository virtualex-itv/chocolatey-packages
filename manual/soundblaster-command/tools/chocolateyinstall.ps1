$ErrorActionPreference  = 'Stop'

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://files.creative.com/creative/bin/apps/swureleases/win/sbcommand/release/CreativeSBCommandSetup_3.5.10.00.exe'
$checksum               = '2b6d9bcd9f0a436c90a34e3af5ee3706c3e749cbe703ebddccfad9c21747a722'
$checksumType           = 'sha256'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  softwareName          = 'Sound Blaster Command*'
  url                   = $url
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = '/SP- /VERYSILENT /NORESTART'
  validExitCodes        = @(0, 3010, 1605, 1614, 1641)
}

Install-ChocolateyPackage @packageArgs
