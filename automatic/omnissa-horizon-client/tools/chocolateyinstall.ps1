$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://download3.omnissa.com/software/CART27FQ3_WIN_2609/Omnissa-Horizon-Client-2609-8.20.0-39382986705.exe'
$checksum               = '20f67cb7d1878a7a4d35afb19be082d839975b1ca5506da3792dd03fe4174f4e'
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
