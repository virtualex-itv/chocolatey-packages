$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://lens-binaries.s3-eu-west-1.amazonaws.com/ide/Lens%20Setup%205.5.0-latest.20220525.1.exe'
$checksum               = 'ef08daaa0cd36812e714dec3683da034ef20d09fbd0397809a7aa523d3c647d7'
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
