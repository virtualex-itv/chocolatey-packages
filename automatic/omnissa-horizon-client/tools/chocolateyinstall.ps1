$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://download3.omnissa.com/software/CART26FQ2_WIN_2506.2/Omnissa-Horizon-Client-2506-8.16.2-18323197680.exe'
$checksum               = 'd2c87121c90f252590c06f2473120349f6f214dfbe06262ec3c6ac2757391a24'
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
