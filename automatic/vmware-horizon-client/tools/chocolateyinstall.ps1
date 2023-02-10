$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://download3.vmware.com/software/CART23FQ4_WIN_2212.1/VMware-Horizon-Client-2212.1-8.8.1-21249081.exe'
$checksum               = '400dcd54a430bcfd7c5678905498975ace1dad0cd32e8d5fc36dd2e52f198f7e'
$checksumType           = 'sha256'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  url                   = $url
  softwareName          = "VMware Horizon Client*"
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = '/silent /norestart'
  validExitCodes        = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
