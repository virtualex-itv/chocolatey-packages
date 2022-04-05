$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://download3.vmware.com/software/CART23FQ1_WIN_2203/VMware-Horizon-Client-2203-8.5.0-19584195.exe'
$checksum               = '5ffc00d377efda8d413e0cc95d9f56c05d33ba8813fd29834a0da9a054bab205'
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
