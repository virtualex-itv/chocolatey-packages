$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://download3.omnissa.com/software/CART26FQ2_WIN_2506.1/Omnissa-Horizon-Client-2506.1-8.16.0-17145568083.exe'
$checksum               = '961e84b8470895098d2f0264bb8d0b6e73d4190c556d41bd26d20e9db2f3163d'
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
