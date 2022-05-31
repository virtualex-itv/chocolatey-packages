$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://downloads.k8slens.dev/ide/Lens%20Setup%205.5.2-latest.20220530.1.exe'
$checksum               = '58baf4cff198f6c21726c90df61d75cbfdc11b73106c1cdcaae2b14accda0c2c'
$checksumType           = 'sha256'
$pp                     = Get-PackageParameters

if ( $pp.ALLUSERS) {

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

  Install-ChocolateyPackage @packageArgs

} else {

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

  Install-ChocolateyPackage @packageArgs

}
