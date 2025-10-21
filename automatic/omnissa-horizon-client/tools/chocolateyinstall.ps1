$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://download3.omnissa.com/software/CART26FQ2_WIN_2506/Omnissa-Horizon-Client-2506-8.16.0-16560451995.exe'
$checksum               = 'ca5887abae262c4078fcfe60657c35f12a87c3506bf2e9236d00a8f0b9d7f5ef'
$checksumType           = 'sha256'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  url                   = $url
  softwareName          = "Omnissa Horizon Client*"
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = '/silent /norestart'
  validExitCodes        = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
