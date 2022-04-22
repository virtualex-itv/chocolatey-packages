$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://lens-binaries.s3-eu-west-1.amazonaws.com/ide/Lens%20Setup%205.4.6-latest.20220421.1.exe'
$checksum               = '11ac9115bdf43a06a95d88fa0a143a91d608a31a32ed05481216c6f04b1b2122'
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
