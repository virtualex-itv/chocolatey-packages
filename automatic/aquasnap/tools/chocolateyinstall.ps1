$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://www.nurgo-software.com/download/AquaSnap.msi'
$checksum               = '1eea35dbf80de91047ea3b258da25f25ca210eefef35e45b4f42bacbd866dcb8'
$checksumType           = 'sha256'

$packageArgs = @{
  packageName           = $env:ChocolateyPackageName
  unzipLocation         = $toolsDir
  fileType              = 'msi'
  softwareName          = "AquaSnap*"
  url                   = $url
  checksum              = $checksum
  checksumType          = $checksumType
  silentArgs            = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes        = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
