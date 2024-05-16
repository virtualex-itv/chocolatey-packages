$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://www.nurgo-software.com/download/AquaSnap.msi'
$checksum               = '49272bba721931d7993492dc75fd24c1fda05cfcbaa030c02e2f0efce6f40347'
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
