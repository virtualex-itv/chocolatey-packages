$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://download3.vmware.com/software/view/viewclients/CART22FQ1/VMware-Horizon-Client-2103-8.2.0-17759012.exe'
$checksum               = '1ffbdab7b88c0527b8f5c05540f92fbf74dd2d804fa20fe328cc18c0bc886fc9'
$checksumType           = 'sha256'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'exe'
  url                   = $url
  softwareName          = 'VMware Horizon Client*'
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = '/silent /norestart'
  validExitCodes        = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
