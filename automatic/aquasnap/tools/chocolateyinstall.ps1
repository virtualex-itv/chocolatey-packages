$ErrorActionPreference  = 'Stop';

$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url                    = 'https://www.nurgo-software.com/download/AquaSnap.msi'
$checksum               = '545DACEF1BF5F01429C5525A22AEC712D8313A41DDA5FEE289EE78CF0B72FEFF'
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
