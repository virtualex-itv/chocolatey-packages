$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://downloads.k8slens.dev/ide/Lens%20Setup%205.5.3-latest.20220602.2.exe'
$checksum               = '67beb8b285cabec3e8ac5f2283c3c05a076466cc8a3839f78fc59d6185bd5ba4'
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
