$ErrorActionPreference  = 'Stop'

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://downloads.k8slens.dev/ide/Lens%20Setup%202026.10.121159-latest.exe'
$checksum               = '6ef4cd57d111de4847b239fc17314e6f1bca45fa3e752f04e9cf5d8adad73f25'
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
