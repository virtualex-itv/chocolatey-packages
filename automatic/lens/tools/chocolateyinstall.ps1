$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://downloads.k8slens.dev/ide/Lens%20Setup%202022.9.260655-latest.exe'
$checksum               = '25c73de0458b6c652eab5bb7d9827912747b6a9ec01a988f71396345b3922aca'
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
  silentArgs            = '/currentuser /disableAutoUpdates /S'
  validExitCodes        = @(0, 3010, 1605, 1614, 1641)
}

if ( $pp.ALLUSERS) {
  $packageArgs['silentArgs'] = '/allusers /disableAutoUpdates /S'
}

Install-ChocolateyPackage @packageArgs
